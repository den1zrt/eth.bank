import { useContext, useRef } from "react";
import { Data } from "../App";

function MarketCard({contract, title}) {
    const inputRef = useRef(null)
    return (
    <div className="card">
        <div className="card-body">
            <h3 className="text-center">{title}</h3>
            <input type="number" className="form-control" ref={inputRef} placeholder="Введите значение..."/>
        </div>
        <div className="card-body dp-flex flex-row justify-content-center">
            <button className="btn theme-primary btn-subtle" onClick={()=>{contract.supply(inputRef.current.value)}}>Supply</button>
            <button className="btn theme-primary btn-subtle" onClick={()=>{contract.withdraw(inputRef.current.value)}}>Withdraw</button>
            <button className="btn theme-primary btn-subtle" onClick={()=>{contract.borrow(inputRef.current.value)}}>Borrow</button>
            <button className="btn theme-primary btn-subtle" onClick={()=>{contract.repay(inputRef.current.value)}}>Repay</button>
        </div>
    </div>
    )
}

function Market() {
    const {ctx} = useContext(Data);
    if (!ctx?.contracts?.markets) return null;
    return (
        <div className="card card-body p-5 m-10 dp-flex gap-5">
            {ctx.contracts.markets.map((object) => (
                <MarketCard contract={object.contract} 
                title={object.title}/>
            ))}
        </div>
    )
}
export default Market;