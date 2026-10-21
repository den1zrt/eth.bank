import { useContext, useRef } from "react";
import { Data } from "../App";

function VaultCard({contract, title}) {
    const inputRef = useRef(null)
    return (
    <div className="card">
        <div className="card-body">
            <h3 className="text-center">{title}</h3>
            <input type="number" className="form-control" ref={inputRef} placeholder="Введите значение..."/>
        </div>
        <div className="card-body dp-flex flex-row justify-content-center">
            <button className="btn theme-primary btn-subtle" onClick={()=>{contract.depositVault(inputRef.current.value)}}>Supply</button>
            <button className="btn theme-primary btn-subtle" onClick={()=>{contract.withdrawVault(inputRef.current.value)}}>Withdraw</button>
        </div>
    </div>
    )
}

function Vault() {
    const {ctx} = useContext(Data);
    if (!ctx?.contracts?.vaults) return null;
    return (
        <div className="card card-body p-5 m-10 dp-flex gap-5">
            {ctx.contracts.vaults.map((object) => (
                <VaultCard contract={object.contract} 
                title={object.title}/>
            ))}
        </div>
    )
}
export default Vault;