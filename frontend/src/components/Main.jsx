
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import {Amplify} from 'aws-amplify';
import AuthProvider, { useAuth, awsconfig } from "./AuthContext";
import HeaderComponent from "./Header"
import FooterComponent from './Footer';
import LoginComponent from './Login';
import LogoutComponent from './Logout';
import ErrorComponent from './Error';
import WelcomeComponent from './Welcome';
import MiRNAComponent from './MiRNA';
import VaccineComponent from './Vaccine';
export default function MainApp() {

  function AuthenticatedRoute({ children }) {
    const authContext = useAuth()
    if (authContext.isAuthenticated) return children
    return <Navigate to="/" />
  }

  Amplify.configure(awsconfig);


  return (
    <div>
      <AuthProvider>
        <BrowserRouter>
          <HeaderComponent />
          <Routes>
            <Route path='/jupyter' element={<VaccineComponent />} />
            <Route path='/' element={<LoginComponent />}></Route>
            <Route path='/login' element={<LoginComponent />}></Route>
            <Route path='/home/:username' element={<WelcomeComponent />}></Route>
            <Route path='/mirna' element={<MiRNAComponent />} />
            <Route path='*' element={<ErrorComponent />}></Route>
            <Route path='/logout' element={<LogoutComponent />} />
          </Routes>
          <FooterComponent />
        </BrowserRouter>
      </AuthProvider>



    </div>
  );
}