const galleries = {
  expo: [
    ["onboarding-1", "Onboarding · Fokus"],
    ["onboarding-2", "Onboarding · Fortschritt"],
    ["onboarding-3", "Onboarding · Lokal"],
    ["dashboard", "Dashboard"],
    ["categories", "Kategorien"],
    ["tasks", "Aufgaben"],
    ["settings", "Einstellungen"],
    ["delete-dialog", "Löschdialog"],
  ],
  flutter: [
    ["onboarding-1", "Onboarding · Fokus"],
    ["onboarding-2", "Onboarding · Streak"],
    ["onboarding-3", "Onboarding · Privat"],
    ["dashboard", "Dashboard"],
    ["task-form", "Neue Aufgabe"],
    ["tasks", "Aufgaben"],
    ["settings", "Einstellungen"],
    ["dashboard-detail", "Dashboard · Details"],
    ["today-tasks", "Heutige Aufgaben"],
  ],
  kotlin: [
    ["onboarding-1", "Onboarding · Überblick"],
    ["onboarding-2", "Onboarding · Streak"],
    ["onboarding-3", "Onboarding · Rhythmus"],
    ["dashboard", "Dashboard"],
    ["dashboard-tasks", "Dashboard · Aufgaben"],
    ["tasks", "Aufgaben & Filter"],
    ["settings-system", "Einstellungen · System"],
    ["settings-dark", "Einstellungen · Dunkel"],
    ["task-edit", "Aufgabe bearbeiten"],
    ["task-new", "Neue Aufgabe"],
  ],
};

const gallery = document.querySelector(".gallery-grid");

function useImage(element, imagePath) {
  const image = new Image();
  image.onload = () => {
    element.style.backgroundImage = `url("${imagePath}")`;
    element.classList.add("has-image");
    element.querySelector(".screen-fallback")?.remove();
  };
  image.src = imagePath;
}

function renderGallery(stack) {
  gallery.replaceChildren();

  galleries[stack].forEach(([file, label], index) => {
    const figure = document.createElement("figure");
    figure.className = "gallery-item";
    const shot = document.createElement("div");
    shot.className = "gallery-shot";
    shot.setAttribute("role", "img");
    shot.setAttribute("aria-label", `${label} von ${stack}`);
    const caption = document.createElement("figcaption");
    caption.innerHTML = `<strong>${label}</strong><span>${String(index + 1).padStart(2, "0")}</span>`;
    figure.append(shot, caption);
    gallery.append(figure);
    useImage(shot, `assets/screenshots/${stack}-${file}.webp`);
  });
}

document.querySelectorAll("[data-image]").forEach((element) => {
  useImage(element, element.dataset.image);
});

document.querySelectorAll("[data-gallery]").forEach((button) => {
  button.addEventListener("click", () => {
    document.querySelectorAll("[data-gallery]").forEach((candidate) => {
      const active = candidate === button;
      candidate.classList.toggle("active", active);
      candidate.setAttribute("aria-selected", String(active));
    });
    renderGallery(button.dataset.gallery);
  });
});

const observer = new IntersectionObserver(
  (entries) => entries.forEach((entry) => entry.isIntersecting && entry.target.classList.add("visible")),
  { threshold: 0.12 },
);

document.querySelectorAll(".reveal").forEach((element) => observer.observe(element));
renderGallery("expo");
