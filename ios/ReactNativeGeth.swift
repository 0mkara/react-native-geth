//
//  ReactNativeGeth.swift
//  ReactNativeGeth
//
//  Created by 0mkar on 04/04/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation
import Geth

@objc(ReactNativeGeth)
class ReactNativeGeth: NSObject {
    private var TAG: String = "Geth"
    private var ETH_DIR: String = ".ethereum"
    private var KEY_STORE_DIR: String = "keystore"
    private let ctx: GethContext
    private var geth_node: NodeRunner
    private var datadir = NSHomeDirectory()

    override init() {
        self.ctx = GethNewContext()
        self.geth_node = NodeRunner()
    }
    @objc(getName)
    func getName() -> String {
        return TAG
    }
    
    /**
     * Creates and configures a new Geth node.
     *
     * @param config  Json object configuration node
     * @param promise Promise
     * @return Return true if created and configured node
     */
    @objc(nodeConfig:resolver:rejecter:)
    func nodeConfig(config: NSObject, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void {
        do {
            let nodeconfig: GethNodeConfig = geth_node.getNodeConfig()!
            var nodeDir: String = ETH_DIR
            var keyStoreDir: String = KEY_STORE_DIR
            var error: NSError?
            
            if(config.value(forKey: "enodes") != nil) {
                geth_node.writeStaticNodesFile(enodes: config.value(forKey: "enodes") as! String)
            }
            if((config.value(forKey: "networkID")) != nil) {
                nodeconfig.setEthereumNetworkID(config.value(forKey: "networkID") as! Int64)
            }
            if((config.value(forKey: "chainID")) != nil) {
                let chainID: Int64 = config.value(forKey: "chainID") as! Int64
                self.geth_node.setChainID(chainID: GethBigInt(chainID))
            }
            if(config.value(forKey: "maxPeers") != nil) {
                nodeconfig.setMaxPeers(config.value(forKey: "maxPeers") as! Int)
            }
            if(config.value(forKey: "genesis") != nil) {
                nodeconfig.setEthereumGenesis(config.value(forKey: "genesis") as! String)
            }
            if(config.value(forKey: "nodeDir") != nil) {
                nodeDir = config.value(forKey: "nodeDir") as! String
            }
            if(config.value(forKey: "keyStoreDir") != nil) {
                keyStoreDir = config.value(forKey: "keyStoreDir") as! String
            }
            
            let node: GethNode = GethNewNode(datadir + "/" + nodeDir, nodeconfig, &error)
            let keyStore: GethKeyStore = GethNewKeyStore(keyStoreDir, GethLightScryptN, GethLightScryptP)
            if error != nil {
                reject(nil, nil, error)
                return
            }
            geth_node.setNodeConfig(nc: nodeconfig)
            geth_node.setKeyStore(ks: keyStore)
            geth_node.setNode(node: node)
            resolve([true] as NSObject)
        } catch let NCErr as NSError {
            NSLog("@", NCErr)
            reject(nil, nil, NCErr)
        }
    }
    
    /**
     * Start creates a live P2P node and starts running it.
     *
     * @param promise Promise
     * @return Return true if started.
     */
    @objc(startNode:rejecter:)
    func startNode(resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void {
        do {
            var result: Bool = false
            if(geth_node.getNode() != nil) {
                try geth_node.getNode()?.start()
                result = true
            }
            resolve([result] as NSObject)
        } catch let NSErr as NSError {
            NSLog("@", NSErr)
            reject(nil, nil, NSErr)
        }
    }
    
    /**
     * Terminates a running node along with all it's services.
     *
     * @param promise Promise
     * @return return true if stopped.
     */
    @objc(stopNode:rejecter:)
    func stopNode(resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void {
        do {
            var result: Bool = false
            if(geth_node.getNode() != nil) {
                try geth_node.getNode()?.stop()
                result = true
            }
            resolve([result] as NSObject)
        } catch let NSErr as NSError {
            NSLog("@", NSErr)
            reject(nil, nil, NSErr)
        }
    }
    
    /**
     * Send transaction.
     *
     * @param passphrase Passphrase
     * @param nonce      Account nonce (use -1 to use last known nonce)
     * @param toAddress  Address destination
     * @param amount     Amount
     * @param gasLimit   Gas limit
     * @param gasPrice   Gas price
     * @param data       Transaction data (optional)
     * @param promise    Promise
     * @return Return String transaction
     */
    @objc(sendTransaction:password:resolver:rejecter:)
    func sendTransaction(transaction: GethTransaction, password: String, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void {
        do {
            let keyStore: GethKeyStore? = self.geth_node.getKeystore()
            let accounts: GethAccounts? = keyStore?.getAccounts()
            let account: GethAccount? = try accounts?.get(0)
            let eth_client: GethEthereumClient? = try self.geth_node.getNode()?.getEthereumClient()
            
            let signedTx: GethTransaction? = try signTx(tx: transaction, account: account!, password: password)
            sendSignedTransaction(signedTx: signedTx!, resolver: resolve, rejecter: reject)
        } catch let sendTxErr as NSError {
            reject(nil, nil, sendTxErr)
        }
    }
    
    /**
     * Send signed transaction.
     *
     * @param signedTx Transaction (signed)
     * @return Return String transaction
     */
    @objc(sendSignedTransaction:resolver:rejecter:)
    func sendSignedTransaction(signedTx: GethTransaction, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void {
        do {
            let eth_client: GethEthereumClient? = try self.geth_node.getNode()?.getEthereumClient()
            try eth_client?.sendTransaction(ctx, tx: signedTx)
        } catch let sendTxErr as NSError {
            reject(nil, nil, sendTxErr)
        }
    }
    
    /**
     * Sign transaction.
     * @param {Transaction} transaction Transaction object
     * @param {String} address Signing address
     * @param {String} passphrase Passphrase
     * @return {String} Returns signed transaction
     */
    @objc(signTransaction:address:passphrase:resolver:rejecter:)
    func signTransaction(transaction: GethTransaction, address: String?, password: String, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void {
        do {
            var account: GethAccount? = self.geth_node.getCoinbase()
            if(address != nil) {
                account = try self.geth_node.getAccountFromHex(address: address!)
            }
            let signedTx: GethTransaction? = try signTx(tx: transaction, account: account!, password: password)
            resolve(signedTx)
        } catch let signErr as NSError {
            reject(nil, nil, signErr)
        }
    }
    
    func signTx(tx: GethTransaction, account: GethAccount, password: String) throws -> GethTransaction? {
        let keyStore: GethKeyStore? = self.geth_node.getKeystore()
        let chainID: GethBigInt = self.geth_node.getChainID()
        let signedTx: GethTransaction? = try keyStore?.signTxPassphrase(account, passphrase: password, tx: tx, chainID: chainID)
        return signedTx
    }
    
}
