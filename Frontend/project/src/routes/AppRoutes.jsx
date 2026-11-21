import { Routes, Route } from 'react-router-dom'

import MainLayout from '../layouts/MainLayout'
import ProtectedRoute from '../components/ProtectedRoute'

import Home from '../pages/home/Home'
import Login from '../pages/security/login/Login'
import Register from '../pages/security/register/Register'
import Users from '../pages/users/Users'

function AppRoutes() {
  return (
    <MainLayout>
      <Routes>
        <Route path="/" element={<Home />} />

        <Route path="/security/login/" element={<Login />} />
        <Route path="/security/register/" element={<Register />} />

        {/* Protected Routes */}
        <Route element={<ProtectedRoute />}>
          <Route path="/users/" element={<Users />} />
        </Route>

        <Route path="*" element={<h2>404 - Page Not Found</h2>} />
      </Routes>
    </MainLayout>
  )
}

export default AppRoutes