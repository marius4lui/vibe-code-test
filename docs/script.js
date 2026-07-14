const galleryItems = [
  ["onboarding", "Onboarding"],
  ["dashboard", "Dashboard"],
  ["tasks", "Aufgaben"],
  ["task-form", "Task-Formular"],
  ["dark-mode", "Dark Mode"],
  ["empty-state", "Empty State"],
  ["settings", "Einstellungen"],
  ["recurring", "Phase C · Wiederholung"],
];

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

  galleryItems.forEach(([file, label], index) => {
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
