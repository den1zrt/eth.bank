import { NavLink } from 'react-router-dom'
import 'bootstrap/dist/css/bootstrap.min.css'
function Header(){
    return(
        <nav className="d-flex justify-content-around p-5">
            <h3>PLH</h3>
            {/* <NavLink to="/" className="text-decoration-none">SHitbank</NavLink> */}
            <NavLink to="/dashboard" className="btn theme-info btn-subtle btn-lg w-9">Dashboard</NavLink>
            <NavLink to="/invest" className="btn theme-info btn-subtle btn-lg w-9">Invest</NavLink>
            <NavLink to="/borrow" className="btn theme-info btn-subtle btn-lg w-9">Borrow</NavLink>
            <NavLink to="/profile" className="btn theme-info btn-subtle btn-lg w-9">Profile</NavLink>
        </nav>
    )
}
export default Header