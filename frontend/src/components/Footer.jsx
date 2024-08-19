import {useAuth}  from './AuthContext'

export default  function FooterComponent() {

    const authContext = useAuth()
    const isAuthenticated = authContext.isAuthenticated
    const username = authContext.username

    return (
        <footer className="border-top border-light border-5 mb-5 p-2">
            <div className="container">
                 { isAuthenticated && <p> welcome {username}, Thank you for using our App.  </p>  }
                 { !isAuthenticated && <p> you are not yet login </p>  }
            </div>
        </footer>
    )
}