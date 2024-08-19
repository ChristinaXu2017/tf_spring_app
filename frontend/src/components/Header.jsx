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
                <div className="created-by"> Tools for Genome & Transcriptome -- miRNA preditcor</div>

                <div className="row">
                    <nav className="navbar navbar-expand-lg">


                        <div className="collapse navbar-collapse">
                            <ul className="navbar-nav">
                                <li className="nav-item">
                                    <Link className="nav-link" href="https://bioweb01.qut.edu.au/benthTPM/index.html">Home</Link>
                                </li>
                                <li>
                                    <Link className="nav-link" to="/miRNA">miRNA</Link>
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


