import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Card,
  Button,
  TextField,
  Snackbar,
  CircularProgress,
} from '@mui/material';
import AuthService from './services/AuthService';
import SpinnerService from './services/SpinnerService';

const StateTypes = {
  ORDINARY_LOGIN: 1,
  FIRST_LOGIN: 2,
  PASSWORD_RESET: 3,
};

const LoginPage = () => {
  const [state, setState] = useState(StateTypes.ORDINARY_LOGIN);
  const [form, setForm] = useState({
    email: '',
    password: '',
    newPassword: '',
    resetCode: '',
  });
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const [snackbar, setSnackbar] = useState({ open: false, message: '' });
  const navigate = useNavigate();

  const validate = () => {
    const newErrors = {};
    if (!form.email) newErrors.email = 'Email is required';
    if (!form.password) newErrors.password = 'Password is required';
    if (state === StateTypes.FIRST_LOGIN && form.password === form.newPassword) {
      newErrors.newPassword = 'Password must be different';
    }
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prevForm) => ({ ...prevForm, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validate()) return;

    setLoading(true);
    SpinnerService.start();

    try {
      switch (state) {
        case StateTypes.FIRST_LOGIN:
          const newPasswordSuccess = await AuthService.newPassword(form.newPassword);
          if (newPasswordSuccess) {
            navigate('/');
          } else {
            setSnackbar({ open: true, message: 'Something went wrong, please contact admin!' });
          }
          break;
        case StateTypes.PASSWORD_RESET:
          // Handle password reset logic here
          break;
        case StateTypes.ORDINARY_LOGIN:
          const signInSuccess = await AuthService.signIn(form.email, form.password);
          if (signInSuccess === true) {
            navigate('/');
          } else if (signInSuccess === false) {
            setSnackbar({ open: true, message: 'Please recheck username and password!' });
          } else if (signInSuccess === 'NEW_PASSWORD_REQUIRED') {
            setState(StateTypes.FIRST_LOGIN);
          }
          break;
        default:
          break;
      }
    } catch (error) {
      console.error(error);
    } finally {
      SpinnerService.end();
      setLoading(false);
    }
  };

  const handleForgotPassword = () => {
    if (form.email) {
      setState(StateTypes.PASSWORD_RESET);
    } else {
      setErrors((prevErrors) => ({ ...prevErrors, email: 'Email is required' }));
    }
  };

  return (
    <Card>
      <form onSubmit={handleSubmit}>
        <TextField
          label="Email"
          name="email"
          value={form.email}
          onChange={handleChange}
          error={!!errors.email}
          helperText={errors.email}
          fullWidth
          margin="normal"
        />
        <TextField
          label="Password"
          name="password"
          type="password"
          value={form.password}
          onChange={handleChange}
          error={!!errors.password}
          helperText={errors.password}
          fullWidth
          margin="normal"
        />
        {state === StateTypes.FIRST_LOGIN && (
          <TextField
            label="New Password"
            name="newPassword"
            type="password"
            value={form.newPassword}
            onChange={handleChange}
            error={!!errors.newPassword}
            helperText={errors.newPassword}
            fullWidth
            margin="normal"
          />
        )}
        {state === StateTypes.PASSWORD_RESET && (
          <TextField
            label="Reset Code"
            name="resetCode"
            value={form.resetCode}
            onChange={handleChange}
            error={!!errors.resetCode}
            helperText={errors.resetCode}
            fullWidth
            margin="normal"
          />
        )}
        <Button type="submit" variant="contained" color="primary" disabled={loading}>
          {loading ? <CircularProgress size={24} /> : 'Login'}
        </Button>
        <Button onClick={handleForgotPassword} color="secondary">
          Forgot Password
        </Button>
      </form>
      <Snackbar
        open={snackbar.open}
        message={snackbar.message}
        autoHideDuration={6000}
        onClose={() => setSnackbar({ open: false, message: '' })}
      />
    </Card>
  );
};

export default LoginPage;
