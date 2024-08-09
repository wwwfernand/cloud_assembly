import UserStatusController from "controllers/user_status_controller";

import {
  ClassicEditor,
  AccessibilityHelp,
  Alignment,
  Autoformat,
  AutoLink,
  Autosave,
  BlockQuote,
  BlockToolbar,
  Bold,
  Code,
  CodeBlock,
  Essentials,
  FindAndReplace,
  FontBackgroundColor,
  FontColor,
  FontFamily,
  FontSize,
  GeneralHtmlSupport,
  Heading,
  Highlight,
  HorizontalLine,
  HtmlComment,
  HtmlEmbed,
  Indent,
  IndentBlock,
  Italic,
  Link,
  List,
  Paragraph,
  RemoveFormat,
  SelectAll,
  ShowBlocks,
  SourceEditing,
  SpecialCharacters,
  SpecialCharactersArrows,
  SpecialCharactersCurrency,
  SpecialCharactersEssentials,
  SpecialCharactersLatin,
  SpecialCharactersMathematical,
  SpecialCharactersText,
  Strikethrough,
  Style,
  Subscript,
  Superscript,
  Table,
  TableCaption,
  TableCellProperties,
  TableColumnResize,
  TableProperties,
  TableToolbar,
  TextTransformation,
  Underline,
  Undo,
  Image,
  AutoImage,
} from "ckeditor5";

const STATES = {
  publish_now: "publish_now",
  publish_later: "publish_later",
};

export default class extends UserStatusController {
  static targets = [
    "errorBox",
    "editor",
    "articleForm",
    "title",
    "imageLink",
    "tagList",
    "tagListBox",
    "publishNowBtn",
    "publishLaterBox",
    "publishTime",
  ];

  static values = {
    tagList: { type: Array, default: [] },
    indexUrl: { type: String },
    content: { type: String },
  };

  static outlets = ["user-status"];

  editor = null;

  connect() {
    this.loadEditor();
  }

  loadEditor(e) {
    const initialData = this.editorTarget.dataset.initialData || "";
    ClassicEditor.create(this.editorTarget, this.#defaultConfig())
      .then((newEditor) => {
        this.editor = newEditor;
        this.editor.model.document.on("change:data", () => {
          window.dispatchEvent(new CustomEvent("input"));
        });
        this.editor.setData(initialData);
      })
      .catch((error) => console.error(error));
  }

  userLoggedIn() {
    this.togglePublishElements();
  }

  updateFormInputs() {
    this.togglePublishElements();
  }

  updateContent() {
    this.contentValue = this.editor.getData();
    this.togglePublishElements();
  }

  updateTagList(e) {
    if (this.isEmptyOrSpaces(this.tagListTarget.value)) return;
    this.tagListValue = this.tagListTarget.value
      .replace(/,/g, " ")
      .replace(/[^a-z0-9 ]/g, "")
      .replace(/ +/g, " ")
      .trim()
      .toLowerCase()
      .split(" ");
    this.tagListValue = [...new Set(this.tagListValue)]; // unique only
    let tagSpans = "";
    this.tagListValue.forEach((tag) => (tagSpans += `<span>${tag}</span>`));
    this.tagListBoxTarget.innerHTML = tagSpans;
  }

  onSubmit(e) {
    e.preventDefault();
    const state = e.submitter.value;
    const ulTag = this.errorBoxTarget.getElementsByTagName("ul")[0];
    const validationErrors = this.#validateForm(state);
    if (validationErrors.length > 0) {
      this.addErrMsgs(ulTag, validationErrors);
      this.errorBoxTarget.classList.remove("hidden");
      this.scrollToTop();
      return;
    }
    var formData = new FormData(this.articleFormTarget);
    formData.append(
      "article[draft_section_attributes][html_body]",
      this.contentValue,
    );
    formData.append("state", state);

    fetch(this.articleFormTarget.action, {
      method: "POST",
      body: formData,
    }).then((response) => {
      if (response.ok) {
        response
          .json()
          .then((data) => (document.location.href = this.indexUrlValue));
      } else {
        let errorStatus = response.status;
        response.json().then((data) => {
          if (errorStatus == 422 || errorStatus == 403) {
            this.addErrMsgs(ulTag, data);
          } else {
            this.addErrMsgs(ulTag, [data.message]);
          }
          this.errorBoxTarget.classList.remove("hidden");
          this.scrollToTop();
          if (errorStatus === 403) {
            this.dispathLoginModal();
          }
        });
      }
    });
  }

  togglePublishElements() {
    if (
      this.userStatusOutlets.length == 0 ||
      !this.userStatusOutlet ||
      !this.userStatusOutlet.hasUsernameValue
    ) {
      this.publishNowBtnTarget.classList.add("hidden");
      this.publishLaterBoxTarget.classList.add("hidden");
      return;
    }
    if (
      this.isEmptyOrSpaces(this.titleTarget.value) ||
      this.isEmptyOrSpaces(this.imageLinkTarget.value) ||
      this.isEmptyOrSpaces(this.contentValue)
    ) {
      this.publishNowBtnTarget.classList.add("hidden");
      this.publishLaterBoxTarget.classList.add("hidden");
      return;
    }
    this.publishNowBtnTarget.classList.remove("hidden");
    this.publishLaterBoxTarget.classList.remove("hidden");
  }

  #validateForm(state) {
    let inputErrors = [];
    if (this.isEmptyOrSpaces(this.titleTarget.value))
      inputErrors.push("title can't be blank");
    if (state == STATES.publish_now || state == STATES.publish_later) {
      if (this.isEmptyOrSpaces(this.imageLinkTarget.value))
        inputErrors.push("image_link can't be blank");
      if (this.isEmptyOrSpaces(this.contentValue))
        inputErrors.push("publish_section can't be blank");
    }
    if (state == STATES.publish_later) {
      if (
        this.isEmptyOrSpaces(this.publishTimeTarget.value) ||
        new Date(this.publishTimeTarget.value) <= new Date()
      )
        inputErrors.push("publish_at must be a future date");
    }
    return inputErrors;
  }

  #defaultConfig() {
    return {
      toolbar: {
        items: [
          "sourceEditing",
          "undo",
          "redo",
          "|",
          "showBlocks",
          "findAndReplace",
          "selectAll",
          "|",
          "heading",
          "style",
          "|",
          "fontSize",
          "fontFamily",
          "fontColor",
          "fontBackgroundColor",
          "|",
          "bold",
          "italic",
          "underline",
          "strikethrough",
          "subscript",
          "superscript",
          "bulletedList",
          "numberedList",
          "code",
          "removeFormat",
          "|",
          "specialCharacters",
          "horizontalLine",
          "link",
          "insertTable",
          "highlight",
          "blockQuote",
          "codeBlock",
          "htmlEmbed",
          "|",
          "alignment",
          "|",
          "indent",
          "outdent",
          "|",
          "accessibilityHelp",
        ],
        shouldNotGroupWhenFull: false,
      },
      plugins: [
        AccessibilityHelp,
        Alignment,
        Autoformat,
        AutoLink,
        Autosave,
        BlockQuote,
        BlockToolbar,
        Bold,
        Code,
        CodeBlock,
        Essentials,
        FindAndReplace,
        FontBackgroundColor,
        FontColor,
        FontFamily,
        FontSize,
        GeneralHtmlSupport,
        Heading,
        Highlight,
        HorizontalLine,
        HtmlComment,
        HtmlEmbed,
        Image,
        AutoImage,
        Indent,
        IndentBlock,
        Italic,
        Link,
        List,
        Paragraph,
        RemoveFormat,
        SelectAll,
        ShowBlocks,
        SourceEditing,
        SpecialCharacters,
        SpecialCharactersArrows,
        SpecialCharactersCurrency,
        SpecialCharactersEssentials,
        SpecialCharactersLatin,
        SpecialCharactersMathematical,
        SpecialCharactersText,
        Strikethrough,
        Style,
        Subscript,
        Superscript,
        Table,
        TableCaption,
        TableCellProperties,
        TableColumnResize,
        TableProperties,
        TableToolbar,
        TextTransformation,
        Underline,
        Undo,
      ],
      blockToolbar: [
        "fontSize",
        "fontColor",
        "fontBackgroundColor",
        "|",
        "bold",
        "italic",
        "|",
        "link",
        "insertTable",
        "|",
        "indent",
        "outdent",
      ],
      fontFamily: {
        supportAllValues: true,
      },
      fontSize: {
        options: [10, 12, 14, "default", 18, 20, 22],
        supportAllValues: true,
      },
      heading: {
        options: [
          {
            model: "paragraph",
            title: "Paragraph",
            class: "ck-heading_paragraph",
          },
          {
            model: "heading1",
            view: "h1",
            title: "Heading 1",
            class: "ck-heading_heading1",
          },
          {
            model: "heading2",
            view: "h2",
            title: "Heading 2",
            class: "ck-heading_heading2",
          },
          {
            model: "heading3",
            view: "h3",
            title: "Heading 3",
            class: "ck-heading_heading3",
          },
          {
            model: "heading4",
            view: "h4",
            title: "Heading 4",
            class: "ck-heading_heading4",
          },
          {
            model: "heading5",
            view: "h5",
            title: "Heading 5",
            class: "ck-heading_heading5",
          },
          {
            model: "heading6",
            view: "h6",
            title: "Heading 6",
            class: "ck-heading_heading6",
          },
        ],
      },
      htmlSupport: {
        allow: [
          {
            name: /^.*$/,
            styles: true,
            attributes: true,
            classes: true,
          },
        ],
      },
      initialData: "",
      link: {
        addTargetToExternalLinks: true,
        defaultProtocol: "https://",
        decorators: {
          toggleDownloadable: {
            mode: "manual",
            label: "Downloadable",
            attributes: {
              download: "file",
            },
          },
        },
      },
      placeholder: "Type or paste your content here!",
      style: {
        definitions: [
          {
            name: "Article category",
            element: "h3",
            classes: ["category"],
          },
          {
            name: "Title",
            element: "h2",
            classes: ["document-title"],
          },
          {
            name: "Subtitle",
            element: "h3",
            classes: ["document-subtitle"],
          },
          {
            name: "Info box",
            element: "p",
            classes: ["info-box"],
          },
          {
            name: "Side quote",
            element: "blockquote",
            classes: ["side-quote"],
          },
          {
            name: "Marker",
            element: "span",
            classes: ["marker"],
          },
          {
            name: "Spoiler",
            element: "span",
            classes: ["spoiler"],
          },
          {
            name: "Code (dark)",
            element: "pre",
            classes: ["fancy-code", "fancy-code-dark"],
          },
          {
            name: "Code (bright)",
            element: "pre",
            classes: ["fancy-code", "fancy-code-bright"],
          },
        ],
      },
      table: {
        contentToolbar: [
          "tableColumn",
          "tableRow",
          "mergeTableCells",
          "tableProperties",
          "tableCellProperties",
        ],
      },
    };
  }
}
