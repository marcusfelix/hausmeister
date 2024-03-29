const dictionary = {
  "en": {
    "onboard_string": "Onboard",
    "onboard_title_string": "Let's get started!",
    "onboard_description_string": "Please enter your unit access code to get started",
    "onboard_hint_string": "ABC123",
    "submit_string": "Submit",
    "continue_string": "Continue",
    "welcome_string": "Welcome",
    "login_with_google_string": "Login with Google",
    "login_with_email_string": "Login with Email",
    "create_account_string": "Create Account",
    "name_string": "Name",
    "email_string": "Email",
    "password_string": "Password",
    "password_reset_string": "Password Reset",
    "you_will_receive_email_string": "You will receive an email with instructions on how to reset your password.",
    "cancel_string": "Cancel",
    "forgot_password_string": "Forgot Password?",
    "login_string": "Login",
    "settings_string": "Settings",
    "upload_profile_image_string": "Upload Profile Image",
    "change_password_string": "Change Password",
    "delete_account_string": "Delete Account",
    "logout_string": "Logout",
    "are_you_sure_question_string": "Are you sure?",
    "delete_account_question_string": "Are you sure you want to delete your account?",
    "this_action_will_delete_string": "This action will delete all your data and cannot be undone.",
    "delete_string": "Delete",
    "tenants_string": "Roommates",
    "add_tenant_string": "Invite",
    "no_tickets_string": "No tickets found",
    "edit_ticket_string": "Edit Ticket",
    "new_ticket_string": "New Ticket",
    "issue_string": "Issue",
    "request_string": "Request",
    "other_string": "Other",
    "open_string": "Open",
    "closed_string": "Closed",
    "aknowledge_string": "Aknowledged",
    "short_title_string": "Short Title",
    "complete_description_string": "Complete Description",
    "phone_number_string": "15555551234",
    "phone_string": "Phone",
    "invite_string": "Invite",
    "invite_tenant_string": "Invite a roommate",
    "invite_tenant_following_code_string": "Ask your roommate to download the app and enter the following code to join your unit:",
    "save_string": "Save",
    "unknown_error_string": "An unknown error occured",
  }
};

translate(String key) => dictionary['en']?[key] ?? key;