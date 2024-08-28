import { createContext, useContext, useState } from "react";
import { Auth } from 'aws-amplify';

// with cognito configuration
export const awsconfig = {
    Auth: {

        region: process.env.REACT_APP_COGNITO_REGION,
        userPoolId: process.env.REACT_APP_USER_POOL_ID,
        userPoolWebClientId: process.env.REACT_APP_USER_POOL_CLIENT_ID
    }
};

//1: Create a Context
export const AuthContext = createContext()
export const useAuth = () => useContext(AuthContext)

//2: Share the created context with other components
export default function AuthProvider({ children }) {

    const [username, setUsername] = useState("");
    //Put some state in the context
    const [isAuthenticated, setAuthenticated] = useState(false)
    const [token, setToken] = useState(null)

    async function login(username, password) {

        try {
            const user = await Auth.signIn(username, password);
            setAuthenticated(true)
            setUsername(username)
            setToken(user.signInUserSession.idToken.jwtToken);
            return true

        } catch (error) {
            console.error("Login failed", error);
            logout()
            return false
        }
    }

    function logout() {
        Auth.signOut();
        setAuthenticated(false);
        setToken(null);
        setUsername("")
    }

    return (
        <AuthContext.Provider value={{ username, isAuthenticated, token, login, logout }}>
            {children}
        </AuthContext.Provider>
    )
}