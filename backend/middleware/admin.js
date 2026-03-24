/**
 * Middleware to restrict access to administrators.
 * Depends on verifyToken middleware having already run.
 */
const isAdmin = (req, res, next) => {
  // Check for 'admin' claim or specific logic
  if (req.user && req.user.admin === true) {
    next();
  } else {
    // For demonstration, you might want to log this attempt
    console.warn(`Unauthorized admin access attempt by UID: ${req.user?.uid}`);
    return res.status(403).json({ error: 'Forbidden: Admin access required' });
  }
};

module.exports = isAdmin;
