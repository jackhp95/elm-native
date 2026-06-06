import { test, expect } from "@playwright/test";

test.beforeEach(async ({ page }) => {
  // navigator.doNotTrack is null in headless Chromium but the Elm decoder
  // expects a string. Patch it so the window decoder chain doesn't fail.
  await page.addInitScript(() => {
    if (navigator.doNotTrack === null) {
      Object.defineProperty(navigator, "doNotTrack", {
        value: "unspecified",
        configurable: true,
      });
    }
  });

  await page.goto("/");
});

// -----------
// Form Tests
// -----------

test.describe("Form", () => {
  test("initial state has empty current values", async ({ page }) => {
    const currentValues = page.getByTestId("form-current-values");
    await expect(currentValues).toBeVisible();
    await expect(currentValues).toHaveText("");
  });

  test("radio buttons produce correct value", async ({ page }) => {
    await page.locator("#kraken").check();
    const current = page.getByTestId("form-current-values");
    await expect(current).toContainText("monster=kraken");

    await page.locator("#sasquatch").check();
    await expect(current).toContainText("monster=sasquatch");
    await expect(current).not.toContainText("monster=kraken");
  });

  test("checkboxes accumulate values", async ({ page }) => {
    await page.locator("#fruit").check();
    const current = page.getByTestId("form-current-values");
    await expect(current).toContainText("snacks=fruit");

    await page.locator("#candy").check();
    await expect(current).toContainText("snacks=fruit");
    await expect(current).toContainText("snacks=candy");

    await page.locator("#fruit").uncheck();
    await expect(current).not.toContainText("snacks=fruit");
    await expect(current).toContainText("snacks=candy");
  });

  test("text input captures typed value", async ({ page }) => {
    const input = page.locator('input[name="input"]');
    await input.fill("hello world");
    await input.blur();
    const current = page.getByTestId("form-current-values");
    await expect(current).toContainText("input=hello world");
  });

  test("single select captures selected option", async ({ page }) => {
    const select = page.locator('select[name="select"]');
    await select.selectOption("2nd text");
    const current = page.getByTestId("form-current-values");
    await expect(current).toContainText("select=2nd text");
  });

  test("multi-select captures multiple selections", async ({ page }) => {
    const select = page.locator('select[name="select[multiple]"]');
    await select.selectOption(["1st text", "3rd text"]);
    const current = page.getByTestId("form-current-values");
    await expect(current).toContainText("select[multiple]=1st text");
    await expect(current).toContainText("select[multiple]=3rd text");
  });

  test("textarea captures content", async ({ page }) => {
    const textarea = page.locator('textarea[name="textarea"]');
    await textarea.fill("new content");
    await textarea.blur();
    const current = page.getByTestId("form-current-values");
    await expect(current).toContainText("textarea=new content");
  });

  test("range input captures value on change", async ({ page }) => {
    const range = page.locator('input[name="input[type=\'range\']"]');
    await range.fill("75");
    const current = page.getByTestId("form-current-values");
    await expect(current).toContainText("input[type='range']=75");
  });

  test("disable_GET checkbox toggles submit behavior", async ({ page }) => {
    const checkbox = page.locator('input[name="disable_GET"]');
    await checkbox.check();
    const current = page.getByTestId("form-current-values");
    await expect(current).toContainText("disable_GET=on");

    await checkbox.uncheck();
    await expect(current).not.toContainText("disable_GET");
  });
});

// -------------
// Window Tests
// -------------

test.describe("Window", () => {
  test("initial state shows only the button", async ({ page }) => {
    const button = page.getByTestId("get-window-data");
    await expect(button).toBeVisible();
    await expect(button).toHaveText("Get Window Data");

    const data = page.getByTestId("window-data");
    await expect(data).not.toBeVisible();
  });

  test("clicking button reveals window data", async ({ page }) => {
    await page.getByTestId("get-window-data").click();
    const data = page.getByTestId("window-data");
    await expect(data).toBeVisible();
  });

  test("location shows the current URL", async ({ page }) => {
    await page.getByTestId("get-window-data").click();
    const location = page.getByTestId("window-location");
    await expect(location).toContainText("localhost");
  });

  test("deterministic fields have expected values", async ({ page }) => {
    await page.getByTestId("get-window-data").click();

    await expect(page.getByTestId("window-onLine")).toHaveText("True");
    await expect(page.getByTestId("window-hasBeenActive")).toHaveText("True");
    await expect(page.getByTestId("window-isActive")).toHaveText("True");
    await expect(page.getByTestId("window-pdfViewerEnabled")).toHaveText("False");
    await expect(page.getByTestId("window-userAgentData-mobile")).toHaveText("False");
    await expect(page.getByTestId("window-virtualKeyboard-overlaysContent")).toHaveText("False");
    await expect(page.getByTestId("window-locationbar")).toHaveText("True");
    await expect(page.getByTestId("window-menubar")).toHaveText("True");
    await expect(page.getByTestId("window-scrollbars")).toHaveText("True");
    await expect(page.getByTestId("window-toolbar")).toHaveText("True");
    await expect(page.getByTestId("window-maxTouchPoints")).toHaveText("0");
    await expect(page.getByTestId("window-vendor")).toHaveText("Google Inc.");
    await expect(page.getByTestId("window-vendorSub")).toHaveText("");
    await expect(page.getByTestId("window-styleMedia")).toHaveText("screen");
    await expect(page.getByTestId("window-doNotTrack")).toHaveText("Unspecified");
    await expect(page.getByTestId("window-speechSynthesis-paused")).toHaveText("False");
    await expect(page.getByTestId("window-speechSynthesis-pending")).toHaveText("False");
    await expect(page.getByTestId("window-speechSynthesis-speaking")).toHaveText("False");
  });

  test("environment-dependent fields are present and non-empty", async ({ page }) => {
    await page.getByTestId("get-window-data").click();

    const fields = [
      "window-userAgent",
      "window-language",
      "window-languages",
      "window-platform",
      "window-devicePixelRatio",
      "window-hardwareConcurrency",
      "window-deviceMemory",
      "window-userAgentData-platform",
    ];

    for (const testId of fields) {
      const el = page.getByTestId(testId);
      await expect(el).toBeVisible();
      await expect(el).not.toHaveText("");
    }
  });
});
