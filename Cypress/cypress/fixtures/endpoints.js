const endpoints = {
  query: () => "/query",
  status: () => "/status",
  login: () => "/login",
  getAllUsers: () => "/users",
  getUserById: (user_id) => `/getUser/${user_id}`,
  updatePassword: () => "/update/password",
  createUser: () => "/create",
  resetPassword: () => "/reset/password",
  updateDetails: () => "/update/details",
  updateState: () => "/update/state",
  createProject: () => "/create_project",
  getProjectById: (project_id) => `/get_project/${project_id}`,
  getUserWithProject: (username) => `/get_user_with_project/${username}`,
  listProjects: () => "/list_projects",
  updateProjectName: () => "/update_projectname",
  sendInvitation: () => "/send_invitation",
  acceptInvitation: () => "/accept_invitation",
  declineInvitation: () => "/decline_invitation",
  removeInvitation: () => "/remove_invitation",
  leaveProject: () => "/leave_project",
  licenseUpload: () => "/license/upload"
};

export default endpoints;
