import { Link } from 'react-router-dom'
import { useAuth } from './AuthContext'

function HeaderComponent() {

    const authContext = useAuth()
    const isAuthenticated = authContext.isAuthenticated
    console.log(authContext.number);
    console.log(authContext.isAuthenticated);

    return (

        <header className="border-bottom border-light border-5 mb-5 p-2">

            <div className="container">
                <div className="created-by"> Tools for Omics data -- Vaccine Design</div>

                <div className="row">
                    <nav className="navbar navbar-expand-lg">


                        <div className="collapse navbar-collapse">
                            <ul className="navbar-nav">
                                <li className="nav-item">
                                    <Link className="nav-link" to="/home/VaccineUser">Home</Link>
                                </li>
                                <li>
                                    <Link className="nav-link" to="/miRNA">RiboTree</Link>
                                </li>
                                <li>
                                    <Link className="nav-link" to="/miRNA">LinearDesign</Link>
                                </li>
                                <li>
                                    <Link className="nav-link" to="/jupyter">JupyterNotebook</Link>
                                </li>
                            </ul>
                        </div>
                        <ul className="navbar-nav">
                            <li className="nav-item">
                                {!isAuthenticated && <Link className="nav-link" to="/login">Login</Link>}
                            </li>
                            <li className="nav-item">
                                {isAuthenticated && <Link className="nav-link" to="/logout">Logout</Link>}
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </header>

    )
}


export default HeaderComponent


