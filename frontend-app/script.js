// Form elements
const form = document.getElementById("contact-form")
const nameInput = document.getElementById("name")
const emailInput = document.getElementById("email")
const messageInput = document.getElementById("message")
const submitBtn = document.getElementById("submit-btn")
const btnText = document.getElementById("btn-text")
const spinner = document.getElementById("spinner")
const alert = document.getElementById("alert")
const alertMessage = document.getElementById("alert-message")

// Error message elements
const nameError = document.getElementById("name-error")
const emailError = document.getElementById("email-error")
const messageError = document.getElementById("message-error")

// Email validation regex
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

// Validation functions
function validateName() {
  const value = nameInput.value.trim()

  if (!value) {
    nameError.textContent = "Name is required"
    nameInput.classList.add("error")
    return false
  }

  if (value.length > 100) {
    nameError.textContent = "Name must be 100 characters or less"
    nameInput.classList.add("error")
    return false
  }

  nameError.textContent = ""
  nameInput.classList.remove("error")
  return true
}

function validateEmail() {
  const value = emailInput.value.trim()

  if (!value) {
    emailError.textContent = "Email is required"
    emailInput.classList.add("error")
    return false
  }

  if (!emailRegex.test(value)) {
    emailError.textContent = "Please enter a valid email address"
    emailInput.classList.add("error")
    return false
  }

  emailError.textContent = ""
  emailInput.classList.remove("error")
  return true
}

function validateMessage() {
  const value = messageInput.value.trim()

  if (!value) {
    messageError.textContent = "Message is required"
    messageInput.classList.add("error")
    return false
  }

  if (value.length > 2000) {
    messageError.textContent = "Message must be 2000 characters or less"
    messageInput.classList.add("error")
    return false
  }

  messageError.textContent = ""
  messageInput.classList.remove("error")
  return true
}

// Show alert message
function showAlert(message, type) {
  alertMessage.textContent = message
  alert.className = `alert ${type}`
  alert.style.display = "block"

  // Scroll to top to show alert
  window.scrollTo({ top: 0, behavior: "smooth" })
}

// Hide alert message
function hideAlert() {
  alert.style.display = "none"
}

// Set loading state
function setLoading(isLoading) {
  if (isLoading) {
    submitBtn.disabled = true
    btnText.style.display = "none"
    spinner.style.display = "block"
  } else {
    submitBtn.disabled = false
    btnText.style.display = "block"
    spinner.style.display = "none"
  }
}

// Add real-time validation
nameInput.addEventListener("blur", validateName)
emailInput.addEventListener("blur", validateEmail)
messageInput.addEventListener("blur", validateMessage)

// Form submission
form.addEventListener("submit", async (e) => {
  e.preventDefault()
  hideAlert()

  // Validate all fields
  const isNameValid = validateName()
  const isEmailValid = validateEmail()
  const isMessageValid = validateMessage()

  if (!isNameValid || !isEmailValid || !isMessageValid) {
    showAlert("Please fix the errors above before submitting.", "warning")
    return
  }

  // Prepare form data
  const formData = {
    name: nameInput.value.trim(),
    email: emailInput.value.trim(),
    message: messageInput.value.trim(),
  }

  // Set loading state
  setLoading(true)

  try {
    // TODO: Replace with your actual AWS API Gateway endpoint
    const response = await fetch("https://6wqs6t6qjg.execute-api.eu-west-1.amazonaws.com/contact", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(formData),
    })

    if (!response.ok) {
      throw new Error("Failed to submit form")
    }

    // Success
    showAlert("Thank you for your message! We'll get back to you soon.", "success")
    form.reset()
  } catch (error) {
    console.error("Form submission error:", error)
    showAlert("Something went wrong. Please try again later.", "error")
  } finally {
    setLoading(false)
  }
})
