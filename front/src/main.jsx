import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { createBrowserRouter, RouterProvider, Link } from 'react-router-dom'
import App from './App.jsx'
import Main from "./modules/Main.jsx"
import Dashboard from "./modules/Dashboard.jsx"
import Profile from "./modules/Profile.jsx"

const routes = createBrowserRouter([{
        path: "/",
        element: <App/>,
        children: [
            {
                index: true, element: <Main/>
            },
            {
                path:"/dashboard",
                element: <Dashboard/>
            },
            {
                path:"/invest",
                element:<h1>Invest Page</h1>
            },
            {
                path:"/borrow",
                element:<h1>Borrow Page</h1>
            },{
                path:"/profile",
                element:<Profile/>
            },
            {
                path: "*",
                element: <div style={{textAlign: "center"}}>
                    <h2>sybau get back to dashboard</h2>
                    <Link to="/dashboard"><button className='btn theme-danger btn-solid btn-lg'>Yes sir</button></Link>
                </div>
            }

        ]
    }])

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <RouterProvider router={routes}/>
  </StrictMode>,
)
