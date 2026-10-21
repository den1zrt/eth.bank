import { createContext, useEffect, useState } from 'react'
import { ethers } from 'ethers'
import { Outlet } from "react-router-dom"
import Header from "./modules/Header.jsx"
import { ContractContext } from './assets/ContractContext.js'
import { MARKETS, VAULTS } from './assets/addresses.js'
import marketABI from "./assets/marketABI.js"
import vaultABI from "./assets/vaultABI.js"

export const Data = createContext(null)

function App() {

    const [ctx, setCtx] = useState(null)

    useEffect(() => {
        async function init(){
            if (!window.ethereum) 
                throw new Error("Metamask is not installed")

            const provider = new ethers.BrowserProvider(window.ethereum)
            if (!provider) 
                throw new Error("Data not provided")
            
            const signer = await provider.getSigner()
            const contracts = { markets: [], vaults: [] }
            MARKETS.map((object) => {
                contracts.markets.push({contract: new ContractContext(object.value, marketABI, signer), title: object.key})
            })
            VAULTS.map((object) => {
                contracts.vaults.push({contract: new ContractContext(object.value, vaultABI, signer), title: object.key})
            })
            const address  = await signer.getAddress()
            const balance = await provider.getBalance(address)
            setCtx({provider, signer, contracts, address, balance})
        }
    
        init()
    }, [])

    

    return(
        <>
        <Header/>
        <Data.Provider value={{ctx}}>
            <Outlet/>
        </Data.Provider>
        {/* <footer style={{textAlign: "center", position: "absolute", bottom: "10px", left: "45.4vw"}}>
            <h3 className='btn theme-secondary btn-outline'>denizrt | Проф 2077</h3>
        </footer> */}
        </>
    )
}

export default App
