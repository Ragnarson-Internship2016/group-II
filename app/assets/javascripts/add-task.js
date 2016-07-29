function setupAddTaskFormEvents() {
  var titleInput = document.querySelector(".add-task-form #title"),
      dueDateInput = document.querySelector(".add-task-form #due_date"),
      cancelBtn = document.querySelector(".add-task-form .btn-cancel"),
      submitBtn = document.querySelector(".add-task-form .btn-add");

  titleInput.addEventListener("click", onTitleInputClick);
  dueDateInput.addEventListener("click", onDueDateInputClick);

  cancelBtn.addEventListener("click", onCancelBtnClick);
  submitBtn.addEventListener("click", onSubmitBtnClick);
}

function onTitleInputClick() {
  showAddTaskFormExtra();
}

function onDueDateInputClick() {
  showAddTaskFormExtra();
}

function onCancelBtnClick(e) {
  hideAddTaskFormExtra();

  e.preventDefault();
}

function onSubmitBtnClick() {
  console.log("foo");
  var taskTitle       = document.querySelector(".add-task-form #title").value,
      taskDueDate     = document.querySelector(".add-task-form #due_date").value,
      taskDescription = document.querySelector(".add-task-form #description").value,

      csrfToken       = document.querySelector("meta[name=csrf-token]")
                        .getAttribute("content");

  reqwest({
    url: document.location.pathname + "/tasks",
    method: "post",
    data: {
      task: {
        title: taskTitle,
        due_date: taskDueDate,
        description: taskDescription
      }
    },
    headers: {
      'X-CSRF-Token': csrfToken
    }
  });
}

function showAddTaskFormExtra() {
  var formExtra = document.querySelector(".add-task-form .form-extra");

  formExtra.classList.remove("hidden");
}

function hideAddTaskFormExtra() {
  var formExtra = document.querySelector(".add-task-form .form-extra");

  formExtra.classList.add("hidden");
}

document.addEventListener("turbolinks:load", setupAddTaskFormEvents);
