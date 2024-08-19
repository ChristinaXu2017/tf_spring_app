import { createContext, useContext, useState } from "react";
import { executeBasicAuthenticationService } from "./ApiService"
//1: Create a Context
export const AuthContext = createContext()
export const useAuth = () => useContext(AuthContext)

//2: Share the created context with other components
export default function AuthProvider({ children }) {

    const [username, setUsername] = useState("");
    //Put some state in the context
    const [isAuthenticated, setAuthenticated] = useState(false)

    // function login(username, password) {
    //     if (username === 'John' && password === 'aaa') {
    //         setAuthenticated(true)
    //         setUsername(username)
    //         return true
    //     } else {
    //         setAuthenticated(false)
    //         setUsername(null)
    //         return false
    //     }
    // }

    const [token, setToken] = useState(null)


    async function login(username, password) {

        const baToken = 'Basic ' + window.btoa(username + ":" + password)

        try {

            const response = await executeBasicAuthenticationService(baToken)

            if (response.status == 200) {
                setAuthenticated(true)
                setUsername(username)
                setToken(baToken)
                return true
            } else {
                logout()
                return false
            }
        } catch (error) {
            logout()
            return false
        }
    }







    function logout() {
        setAuthenticated(false)
        setUsername(null)
    }



    return (
        <AuthContext.Provider value={{ username, isAuthenticated, login, logout }}>
            {children}
        </AuthContext.Provider>
    )
}