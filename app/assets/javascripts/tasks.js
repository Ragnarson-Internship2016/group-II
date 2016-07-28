function setupShowMoreItemEvent() {
  var showMoreItem = document.querySelector(".show-more-item");

  showMoreItem.addEventListener("click", onShowMoreItemClick);
}

function onShowMoreItemClick() {
  var doneTasksList = document.querySelector(".done-tasks-list"),
      showMoreItem  = document.querySelector(".show-more-item");

  doneTasksList.classList.toggle("hidden");

  if (showMoreItem.innerText === "Show done tasks") {
    showMoreItem.innerText = "Hide done tasks";
  } else {
    showMoreItem.innerText = "Show done tasks";
  }
}

document.addEventListener("turbolinks:load", setupShowMoreItemEvent);
