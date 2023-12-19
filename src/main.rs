use gloo;

mod app;

use app::App;

fn main() {
    let document = gloo::utils::document();
    let body = document.query_selector("body").unwrap().unwrap();
    let app = document.create_element("app").unwrap();
    body.append_child(&app).unwrap();

    yew::Renderer::<App>::with_root(app).render();
}
