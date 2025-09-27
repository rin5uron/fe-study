# A-one単語カード印刷アドオン 開発ログ
---

## 実装ログ

### 実装日
`2025-09-27`

### 実装結果
*(ここに、実際にスクリプトを設定し、実行してみた結果や感想、課題などを記述してください)*

```
## 1. 概要

### 目的
Googleスプレッドシートで管理している単語帳データを、市販のA-one単語カード用紙（51163想定）にズレなく印刷する。そのための開発プロセスと成果物を記録する。

### 使用ツール
- Googleスプレッドシート
- Google Apps Script
- Googleドキュメント

---

## 2. 計画

### 方針
Googleスプレッドシートの印刷機能では困難な、ミリ単位での厳密なレイアウト制御を実現するため、**Google Apps Script**を利用する。スプレッドシートからデータを読み取り、A-one用紙の仕様に完全に一致する**Googleドキュメント**を自動生成する。

### ユーザーストーリー
1.  ユーザーはスプレッドシート上で、印刷したい単語データが含まれるセル範囲（3列×10行 = 30セル）を選択する。
2.  シートのカスタムメニュー「単語カード印刷」>「選択範囲から作成」を実行する。
3.  スクリプトが起動し、選択されたセルの内容（テキストと書式）を読み取る。
4.  A-one 51163用紙のレイアウト情報に基づき、新しいGoogleドキュメントが生成される。
5.  生成されたドキュメントには、3列×10行のテーブルが配置され、各セルがカード1枚に対応する。
6.  処理が完了すると、ユーザーに生成されたドキュメントのURLが通知される。
7.  ユーザーはそのドキュメントを開き、印刷することで、ズレのない単語カードが完成する。

---

## 3. 実装コード (Google Apps Script)

**【重要】レイアウトの微調整について**
- スクリプト冒頭の `CONFIG` 部分の数値を変更することで、カードのサイズや余白を微調整できます。
- 特に `CARD_HEIGHT` は、A4用紙（縦297mm）に収まるように **25.4mm** を初期値としています。この部分を変更することで微調整できます。

```javascript
/**
 * @OnlyCurrentDocのスクリプトは いま開いてるスプレッドシートだけ にアクセスします」と宣言するアノテーション。
なので 新規に Google ドキュメントを作成する権限が含まれない → 「権限不足」エラーになる。
 *
 * A-one単語カード印刷用ドキュメント生成スクリプト
 */

// --- 設定項目：ここを調整して印刷のズレを修正します ---
const CONFIG = {
  // A4用紙のサイズ (mm)
  PAGE_WIDTH: 210,
  PAGE_HEIGHT: 297,

  // カードの枚数
  COLUMNS: 3,
  ROWS: 10,

  // カード1枚のサイズ (mm)
  CARD_WIDTH: 70,
  CARD_HEIGHT: 25.4, // 35mmだとA4に収まらないため、25.4mmを初期値とする

  // ページ全体の余白 (mm)
  // (用紙サイズ - カード合計サイズ) / 2 で中央揃えにする
  MARGIN_TOP: (297 - (25.4 * 10)) / 2,
  MARGIN_LEFT: (210 - (70 * 3)) / 2,
};
// ----------------------------------------------------


/**
 * スプレッドシートを開いたときにカスタムメニューを追加します。
 */
function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu('単語カード印刷')
    .addItem('選択範囲から作成', 'createWordCards')
    .addToUi();
}

/**
 * 選択範囲から単語カードのGoogleドキュメントを生成します。
 */
function createWordCards() {
  const ui = SpreadsheetApp.getUi();

  // アクティブなスプレッドシートと選択範囲を取得
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  const range = sheet.getActiveRange();

  if (!range) {
    ui.alert('エラー', '先にセル範囲を選択してください。', ui.ButtonSet.OK);
    return;
  }

  const numRows = range.getNumRows();
  const numCols = range.getNumColumns();

  if (numRows !== CONFIG.ROWS || numCols !== CONFIG.COLUMNS) {
    const message = `選択範囲が正しくありません。\n${CONFIG.ROWS}行 × ${CONFIG.COLUMNS}列 の範囲を選択してください。\n\n現在の選択範囲: ${numRows}行 × ${numCols}列`;
    ui.alert('範囲選択エラー', message, ui.ButtonSet.OK);
    return;
  }

  // セルのリッチテキストを取得
  const richTextValues = range.getRichTextValues();

  try {
    // ドキュメントを生成
    const doc = createDocument();
    const body = doc.getBody();
    const table = body.appendTable();

    // テーブルのスタイル設定
    const tableStyle = {};
    tableStyle[DocumentApp.Attribute.BORDER_WIDTH] = 0.5; // 罫線（切り取り線）
    tableStyle[DocumentApp.Attribute.BORDER_COLOR] = '#cccccc';
    table.setAttributes(tableStyle);

    // セルに内容を転記
    for (let i = 0; i < CONFIG.ROWS; i++) {
      const tableRow = table.appendTableRow();
      for (let j = 0; j < CONFIG.COLUMNS; j++) {
        const tableCell = tableRow.appendTableCell();
        const cellData = richTextValues[i][j];
        
        // セルの内容をコピー
        tableCell.clear().appendParagraph('').insertText(0, cellData.getText(), cellData.getTextStyle());
        
        // セルのスタイル設定
        const cellStyle = {};
        cellStyle[DocumentApp.Attribute.WIDTH] = CONFIG.CARD_WIDTH * 2.83465; // mm to points
        cellStyle[DocumentApp.Attribute.HEIGHT] = CONFIG.CARD_HEIGHT * 2.83465; // mm to points
        cellStyle[DocumentApp.Attribute.VERTICAL_ALIGNMENT] = DocumentApp.VerticalAlignment.CENTER;
        cellStyle[DocumentApp.Attribute.PADDING_LEFT] = 5;
        cellStyle[DocumentApp.Attribute.PADDING_RIGHT] = 5;
        tableCell.setAttributes(cellStyle);
      }
    }
    
    doc.saveAndClose();

    // 完了通知
    const url = doc.getUrl();
    const htmlOutput = HtmlService.createHtmlOutput(`<p>単語カードが生成されました。<a href="${url}" target="_blank">ここをクリックしてドキュメントを開く</a></p>`)
      .setWidth(300)
      .setHeight(100);
    ui.showModalDialog(htmlOutput, '生成完了');

  } catch (e) {
    ui.alert('エラー', `処理中にエラーが発生しました: ${e.message}`, ui.ButtonSet.OK);
  }
}

/**
 * A-one用紙のレイアウトで新しいGoogleドキュメントを作成します。
 * @return {Document} 新しく作成されたGoogleドキュメント
 */
function createDocument() {
  const docName = `単語カード_${new Date().toLocaleString('ja-JP')}`;
  const doc = DocumentApp.create(docName);
  const body = doc.getBody();

  // mm to points (1mm = 2.83465 points)
  const points = (mm) => mm * 2.83465;

  // ページ設定
  body.setPageWidth(points(CONFIG.PAGE_WIDTH));
  body.setPageHeight(points(CONFIG.PAGE_HEIGHT));
  body.setMarginTop(points(CONFIG.MARGIN_TOP));
  body.setMarginBottom(points(CONFIG.MARGIN_TOP));
  body.setMarginLeft(points(CONFIG.MARGIN_LEFT));
  body.setMarginRight(points(CONFIG.MARGIN_LEFT));
  
  // 最初の空の段落を削除
  body.getChild(0).asParagraph().clear();

  return doc;
}
```

---

## 4. 設定手順

1.  **Googleスプレッドシートを開く**: あなたの単語帳スプレッドシートを開きます。
2.  **スクリプトエディタを開く**: 上部メニューから `拡張機能` > `Apps Script` を選択します。
3.  **コードを貼り付ける**:
    -   スクリプトエディタが開いたら、`コード.gs` というファイルに最初から書かれている `function myFunction() { ... }` というコードを全て削除します。
    -   上の「3. 実装コード」に記載されている`javascript`のコードブロックの内容を、全てコピーして貼り付けます。
4.  **プロジェクトを保存**: フロッピーディスクのアイコン（💾）をクリックして、プロジェクトを保存します。プロジェクト名を聞かれたら、「単語カードメーカー」など分かりやすい名前を付けてください。
5.  **承認プロセス**:
    -   一度スプレッドシートの画面に戻り、ページを**再読み込み（リロード）**します。
    -   上部メニューに「単語カード印刷」というカスタムメニューが表示されるはずです。
    -   `単語カード印刷` > `選択範囲から作成` を初めて実行すると、「承認が必要です」というダイアログが表示されます。
    -   `許可を確認` > 自分のGoogleアカウントを選択 > `詳細` > `（安全でないページ）に移動` > `許可` の順にクリックして、スクリプトがあなたのスプレッドシートとGoogleドキュメントを操作することを許可してください。（これはご自身が作成したスクリプトなので安全です）
6.  **完了**: これで設定は完了です。以降はいつでもメニューからスクリプトを実行できます。

