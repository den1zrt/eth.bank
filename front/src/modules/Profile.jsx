import { useContext, useEffect, useState } from "react"
import { Data } from "../App"
import { formatEther } from "ethers"

function UserCard({contract, title}) {
    const [data, setData] = useState([])
    const keys = ["Borrow Token", "Borrow Shares", "Collateral Tokens", "Collateral Shares",
        "Borrow Index", "LTV"]

    useEffect(() => {
        const load = async () => {
            setData(await contract.getUser())
        }
        load()
    },[])

    return(
        <div className="card">
            <div className="card-body">
                <h3>Title: {title}</h3>
            </div>
                {data && keys.map((key, index) => (
                    <div className="card-body" key={key}>
                        <h3>{key}: {String(data[index])}</h3>
                    </div>
                ))}
        </div>
    )

}




function Profile() {
    const { ctx } = useContext(Data)
    if (!ctx) return <p>Loading account…</p>

    return(<>
        <div className="d-flex justify-content-center align-items-center flex-column">
            <h1 className="text-center my-10">Profile</h1>
            <div className="card">
                <div className="card-body">
                    <h3>Address: {ctx.address}</h3>
                </div>
                <div className="card-body">
                    <h3>Balance: {formatEther(ctx.balance.toString())}</h3>
                </div>
            </div>
            <h2 className="my-10">Markets</h2>
            {ctx.contracts.markets.map((object) => (
                <UserCard contract={object.contract} title={object.title}/>
            ))}
        </div>
    </>)
}

export default Profile