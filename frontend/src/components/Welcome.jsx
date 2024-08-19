import {useParams, Link} from 'react-router-dom'

function WelcomeComponent() {

    const {username, password } = useParams()

    console.log(username)
    console.log(password)

    return (
        <div className="WelcomeComponent">
            <h1>Welcome {username} </h1>
            <div>
                You can access our <Link className="nav-link" href="https://bioweb01.qut.edu.au/benthTPM/index.html">Home Page </Link> here!
            </div>
        </div>
    )
}

export default WelcomeComponent