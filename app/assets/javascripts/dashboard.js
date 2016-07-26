function setupTaskItemEvents() {
  var titleElements = document.querySelectorAll(".task-item .task-title"),
      caretElements = document.querySelectorAll(".task-item .fa");

  addEventListenerToElements(titleElements, "click", onTaskTitleClick);
  addEventListenerToElements(caretElements, "click", onTaskCaretClick);
}

function onTaskTitleClick(e) {
  var taskItem   = e.target.parentNode,
      checkboxId = e.target.id || e.target.getAttribute("for"),
      projectId  = checkboxId.split("-")[0],
      taskId     = checkboxId.split("-")[1],

      csrfToken = document.querySelector("meta[name=csrf-token]")
                  .getAttribute("content");

  reqwest({
    url: "/projects/" + projectId + "/tasks/" + taskId + "/done.json",
    method: "put",
    headers: {
      'X-CSRF-Token': csrfToken
    }
  })
    .then(function(response) {
      taskItem.parentNode.removeChild(taskItem);
    });
}

function onTaskCaretClick(e) {
  var taskItem  = e.target.parentNode;

  toggleTaskExtra(taskItem);
  toggleTaskCaret(taskItem);
}

function toggleTaskExtra(taskItem) {
  var taskExtra = taskItem.querySelector(".task-extra");

  taskExtra.classList.toggle("hidden");
}

function toggleTaskCaret(taskItem) {
  var taskCaret = taskItem.querySelector(".fa");

  taskCaret.classList.toggle("fa-caret-down");
  taskCaret.classList.toggle("fa-caret-up");
}

function addEventListenerToElements(elements, type, listener) {
  Array.prototype.forEach.call(elements, function(element) {
    element.addEventListener(type, listener);
  });
}

document.addEventListener("turbolinks:load", setupTaskItemEvents);
