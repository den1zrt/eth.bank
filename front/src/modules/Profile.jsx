import { useContext, useState } from "react"
import { Data } from "../App"
import { formatEther } from "ethers"
import 'bootstrap/dist/css/bootstrap.min.css'

function Profile() {
    const { ctx } = useContext(Data)
    if (!ctx) return <p>Loading account…</p>

    return(<>
        <h1 style={{textAlign: "center", margin:"4vh 0px"}}>Profile</h1>
        <div className="d-flex justify-content-center">
            <div className="card ">
                <div className="card-body">
                    <h3>Address: {ctx.address}</h3>
                </div>
                <div className="card-body">
                    <h3>Balance: {formatEther(ctx.balance.toString())}</h3>
                </div>
            </div>
        </div>
    </>)
}

export default Profile