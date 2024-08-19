import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from './AuthContext'

function LoginComponent() {

    const [username, setUsername] = useState('John')

    const [password, setPassword] = useState('')

    const [showErrorMessage, setShowErrorMessage] = useState(false)

    const navigate = useNavigate();
    const authContext = useAuth()

    function handleUsernameChange(event) {
        setUsername(event.target.value)
    }

    function handlePasswordChange(event) {
        setPassword(event.target.value)
    }

    async function handleSubmit() {
        if (await authContext.login(username, password)) {
            setShowErrorMessage(false)
            navigate(`/mirna`)
        } else {
            setShowErrorMessage(true)
        }
    }
    return (
        <div className="Login" >
            <h1>Time to Login!</h1>
            {showErrorMessage && <div className="alert alert-warning" >Authentication Failed. Please check your credentials.</div>}

            <div className="d-flex justify-content-center align-items-center" >

                <div className="LoginForm">

                    <div class="form-outline mb-4">
                        <label >User Name</label>
                        <input type="string" name="username" value={username} onChange={handleUsernameChange} />

                    </div>


                    <div class="form-outline mb-4">
                        <label >Password</label>
                        <input type="password" name="password" value={password} onChange={handlePasswordChange} />

                    </div>
                    <div>
                        <button type="button" name="login" onClick={handleSubmit} className="btn btn-secondary">login</button>
                    </div>
                </div>
            </div>
        </div >
    )
}

export default LoginComponent

