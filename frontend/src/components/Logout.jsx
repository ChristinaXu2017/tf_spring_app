import {useAuth}  from './AuthContext'

function LogoutComponent() {
    const authContext = useAuth()
    authContext.logout()

    return (
        <div className="LogoutComponent">
            <h1>You are logged out!</h1>
        </div>
    )
}

export default LogoutComponent