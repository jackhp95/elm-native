import "./style.css";
import {Elm as FORM} from "./src/Form.elm";
import {Elm as WINDOW} from "./src/Window.elm";

const window_ = document.querySelector("#window div");
const form_ = document.querySelector("#form div");
const apps = [
  WINDOW.Window.init({
    node: window_,
    flags: { window },
  }),
  FORM.Form.init({
    node: form_,
    flags: { searchParams: [...new URL(location.href).searchParams] },
  }),
];
