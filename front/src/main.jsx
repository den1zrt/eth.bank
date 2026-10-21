import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { createBrowserRouter, RouterProvider, Link } from 'react-router-dom'
import App from './App.jsx'
import Market from './modules/Market.jsx'
import Vault from './modules/Vault.jsx'
import Dashboard from "./modules/Dashboard.jsx"
import Profile from "./modules/Profile.jsx"

const routes = createBrowserRouter([{
        path: "/",
        element: <App/>,
        children: [
            {
                index: true, element: <Dashboard/>
            },
            {
                path:"/market",
                element:<Market/>
            },
            {
                path:"/vault",
                element:<Vault/>
            },{
                path:"/profile",
                element:<Profile/>
            },
            {
                path: "*",
                element: <div style={{textAlign: "center"}}>
                    <h2>sybau get back to dashboard</h2>
                    <Link to="/"><button className='btn theme-danger btn-solid btn-lg'>Yes sir</button></Link>
                </div>
            }

        ]
    }])

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <RouterProvider router={routes}/>
  </StrictMode>,
)
