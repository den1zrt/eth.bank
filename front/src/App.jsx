import { createContext, useEffect, useState } from 'react'
import { ethers } from 'ethers'
import { Outlet } from "react-router-dom"
import Header from "./modules/Header.jsx"
import abi from './assets/abi.js'

import { Contract } from 'ethers'

const contractAddress = ""
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
            const contract = new Contract(contractAddress, abi, provider)
            const address  = await signer.getAddress()
            const balance = await provider.getBalance(address)
            setCtx({provider, signer, contract, address, balance})
        }
    
        init()
    }, [])

    

    return(
        <>
        <Header/>
        <div className='space' style={{margin: "7vh 0px"}}></div>
        <Data.Provider value={{ctx}}>
            <Outlet/>
        </Data.Provider>
        <footer style={{textAlign: "center", position: "absolute", bottom: "10px", left: "45.4vw"}}>
            <h3 className='btn theme-secondary btn-outline'>denizrt | Проф 2077</h3>
        </footer>
        </>
    )
}

export default App
