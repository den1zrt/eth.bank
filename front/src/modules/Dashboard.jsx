import { useContext, useState, useEffect } from "react"
import { Data } from "../App"

function Card({contract, type}) {
    const [object, setObject] = useState(null)
    const [keys, setKeys] = useState(null)
    useEffect(() => {
        const load = async () => {
            if (type == "market"){
                setObject(await contract.getMarket());
                setKeys(["Title", "LLTV", "Borrow Price", "Interest Rate", "Borrow Index"])
            }
            else if (type == "vault"){
                setObject(await contract.getVault())
                setKeys(["Title", "Assets", "Supply", "Owner", "Min Deposit"])
            }
        }   
        load()
        
    },[])

    return(
        <div className="card">
            {object && keys.map((key, index) => (
                <div className="card-body" key={key}>
                    <h3>{key}: {String(object[index])}</h3>
                </div>
            ))}
        </div>
    )
}

function Dashboard() {
    const { ctx } = useContext(Data);

    if (!ctx?.contracts?.markets) return null;
    return (
        <div className="card p-5 m-10 dp-flex gap-5">
            <div className="card card-body">
                <h2 className="text-center">Markets</h2>
                {ctx.contracts.markets.map((contract) => (
                    <Card contract={contract} type="market"/>
                ))}
            </div>
            <div className="card card-body">
                <h2 className="text-center">Vaults</h2>
                {ctx.contracts.vaults.map((contract) => (
                    <Card contract={contract} type="vault"/>
                ))}
            </div>
        </div>
    )
}
export default Dashboard