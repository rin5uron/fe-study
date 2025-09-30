# A-one単語カード印刷アドオン 開発ログ
---
| 2025/09/30（火） | 22:30 | 24:00 | 1h30m | 基本情報：システム戦略・企業活動、GAS調整|
| 2025/09/29（月） | 21:30 | 23:00 | 1h30m | 基本情報：システム戦略・企業活動、GAS調整|
| 2025/09/29（月） | 08:30 | 09:00 | 0h30m | 基本情報：テクノロジ|
| 2025/09/28（日） | 15:30 | 17:30 | 2h00m | 基本情報：システム戦略単語とアプリ過去問|
## 実装ログ

### 実装日
`2025-09-27-`

### 実装結果
*(ここに、実際にスクリプトを設定し、実行してみた結果や感想、課題などを記述してください)*

```
## 1. 概要

### 目的
Googleスプレッドシートで管理している単語帳データを、市販のA-one単語カード用紙（51163）にズレなく印刷する。そのための開発プロセスと成果物を記録する。

### 使用ツール
- Googleスプレッドシート
- Google Apps Script
- Googleドキュメント

---

## 2. 計画

### 現在の状況と課題

**スプレッドシートの状態：**
- 単語データは**既に完璧に整形済み**（3列×10行 = 30面）
- 各セルの書式（太字、色、サイズ、フォント）も設定済み
- 配置（中央寄せ、左寄せ、右寄せ）も適切に設定済み
- 見た目は理想的な状態で、手動調整は不要

**課題：**
- スプレッドシートの印刷機能では**印刷時にズレが発生**する
- A-one 51163用紙の枠に正確に合わせることが困難
- ミリ単位での厳密なレイアウト制御が必要

### 方針
既に整形されたスプレッドシートデータを**そのまま保持**しつつ、**印刷時のズレを最小限**に抑えるため、Google Apps Scriptを利用する。スプレッドシートの書式を完全にコピーし、A-one用紙の仕様に正確に一致するGoogleドキュメントを自動生成する。

**重要なポリシー：**
- 文字書式（太字、色、サイズ、フォント）は完全コピー
- **段落整形は一切しない**（ユーザーの設定を尊重）
- Googleドキュメントの最小余白制限を考慮した最適化
- 微調整レベルの処理に留める

### ユーザーストーリー
1.  ユーザーはスプレッドシート上で、**既に整形済み**の単語データが含まれるセル範囲（3列×10行 = 30セル）を選択する。
2.  シートのカスタムメニュー「単語カード印刷」>「選択範囲から作成」を実行する。
3.  スクリプトが起動し、選択されたセルの内容（テキストと書式）を**そのまま**読み取る。
4.  A-one 51163用紙のレイアウト情報に基づき、**印刷可能領域を最大活用**した新しいGoogleドキュメントが生成される。
5.  生成されたドキュメントには、最適化された3列×10行のテーブルが配置され、各セルがカード1枚に対応する。
6.  処理が完了すると、ユーザーに生成されたドキュメントのURLが通知される。
7.  ユーザーはそのドキュメントを開き、印刷することで、**ズレのない単語カード**が完成する。

---

## 3. 実装コード (Google Apps Script)
Gemini、GPT−5、claude4sonnetを使って実装した上で、手作業で微調整した。

### 
以下手作業修正前のコード。


```javascript
/**
 * A-one（30面：70×25.4mm）単語カード印刷用ドキュメント生成スクリプト
 *
 * ポリシー：
 *  - シートの文字＋書式（太字／斜体／下線／取消線／色／サイズ／フォント／リンク）を
 *    できるだけそのまま Docs の表セルへコピーする
 *  - Docs 側ではページサイズ・余白・表（枠）だけ設定。段落整形は一切しない
 *
 * 注意：
 *  - DocumentApp.create() を使うため @OnlyCurrentDoc は付けない
 *  - 初回実行時に Docs / Drive へのアクセス承認が必要
 */

// ===================== 設定（必要に応じて微調整） =====================
const CONFIG = {
  PAGE_WIDTH: 210,    // A4 幅 (mm)
  PAGE_HEIGHT: 297,   // A4 高 (mm)

  COLUMNS: 3,         // 列数（A-one 30面は 3列×10行）
  ROWS: 10,           // 行数

  CARD_WIDTH: 70,     // 1カードの幅 (mm)
  CARD_HEIGHT: 25.4,  // 1カードの高さ (mm)

  // 中央寄せ余白（= (用紙 - カード合計) / 2）
  MARGIN_TOP: (297 - (25.4 * 10)) / 2,
  MARGIN_LEFT: (210 - (70 * 3)) / 2,

  // 表の罫線（切り取り線の目安）
  BORDER_PT: 0.5,
  BORDER_COLOR: '#cccccc',

  // セル内パディング（pt）
  CELL_PADDING_LEFT_PT: 5,
  CELL_PADDING_RIGHT_PT: 5,
};
const mm2pt = (mm) => mm * 2.83465;
// =====================================================================


/**
 * onOpen
 * シートを開いた時にメニューを追加する。
 * 使い方：シートで 10×3 の範囲を選択 → メニューから実行。
 */
function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu('単語カード印刷')
    .addItem('選択範囲から作成', 'createWordCards')
    .addToUi();
}


/**
 * createWordCards
 * メイン処理：選択範囲（10×3）→ A-one レイアウトの Googleドキュメントを作成。
 * セルのリッチテキスト（書式含む）を各カード枠へコピーする。
 */
function createWordCards() {
  const ui = SpreadsheetApp.getUi();
  const sheet = SpreadsheetApp.getActiveSheet();
  const range = sheet.getActiveRange();

  // 1) 範囲チェック
  if (!range) {
    return ui.alert('エラー', '先にセル範囲を選択してください。', ui.ButtonSet.OK);
  }
  const rows = range.getNumRows();
  const cols = range.getNumColumns();
  if (rows !== CONFIG.ROWS || cols !== CONFIG.COLUMNS) {
    return ui.alert(
      '範囲選択エラー',
      `${CONFIG.ROWS}行 × ${CONFIG.COLUMNS}列 を選んでください。\n（現在: ${rows}行 × ${cols}列）`,
      ui.ButtonSet.OK
    );
  }

  // 2) 範囲のリッチテキストを取得（書式ラン getRuns を扱う）
  const richTextGrid = range.getRichTextValues(); // RichTextValue[][]

  try {
    // 3) A-one 用ページ設定の空Docを用意
    const doc = createDocumentShell_(); // Document
    const body = doc.getBody();

    // 4) A-one の表（枠）を作成（ここでサイズと罫線のみ設定）
    const table = body.appendTable();
    table.setAttributes({
      [DocumentApp.Attribute.BORDER_WIDTH]: CONFIG.BORDER_PT,
      [DocumentApp.Attribute.BORDER_COLOR]: CONFIG.BORDER_COLOR,
    });

    // 5) 各セルへ“書式を保ったまま”流し込み
    for (let r = 0; r < CONFIG.ROWS; r++) {
      const tr = table.appendTableRow();
      for (let c = 0; c < CONFIG.COLUMNS; c++) {
        const tc = tr.appendTableCell();

        // セルの見た目（サイズ・内側余白・縦位置）だけ設定。段落整形はしない
        tc.setAttributes({
          [DocumentApp.Attribute.WIDTH]:  mm2pt(CONFIG.CARD_WIDTH),
          [DocumentApp.Attribute.HEIGHT]: mm2pt(CONFIG.CARD_HEIGHT),
          [DocumentApp.Attribute.PADDING_LEFT]:  CONFIG.CELL_PADDING_LEFT_PT,
          [DocumentApp.Attribute.PADDING_RIGHT]: CONFIG.CELL_PADDING_RIGHT_PT,
          [DocumentApp.Attribute.VERTICAL_ALIGNMENT]: DocumentApp.VerticalAlignment.TOP,
        });

        // シートの RichText を Docs セルに忠実コピー（堅牢版）
        copyRichTextToDocCell_(richTextGrid[r][c], tc);
      }
    }

    // 6) 保存してURL表示
    doc.saveAndClose();
    const url = doc.getUrl();
    ui.showModalDialog(
      HtmlService.createHtmlOutput(
        `<p>単語カードを作成しました。<br><a href="${url}" target="_blank">ドキュメントを開く</a></p>`
      ).setWidth(360).setHeight(120),
      '生成完了'
    );

  } catch (err) {
    ui.alert('エラー', String(err && err.stack ? err.stack : err), ui.ButtonSet.OK);
  }
}


/**
 * createDocumentShell_
 * 新規 Googleドキュメントを作り、ページサイズ・余白を A-one 用に設定。
 * 本文は触らない（空段落を削除しない）。
 */
function createDocumentShell_() {
  const name = `単語カード_${new Date().toLocaleString('ja-JP')}`;
  const doc = DocumentApp.create(name);
  const body = doc.getBody();

  body.setPageWidth(mm2pt(CONFIG.PAGE_WIDTH));
  body.setPageHeight(mm2pt(CONFIG.PAGE_HEIGHT));
  body.setMarginTop(mm2pt(CONFIG.MARGIN_TOP));
  body.setMarginBottom(mm2pt(CONFIG.MARGIN_TOP));
  body.setMarginLeft(mm2pt(CONFIG.MARGIN_LEFT));
  body.setMarginRight(mm2pt(CONFIG.MARGIN_LEFT));

  return doc;
}


/**
 * copyRichTextToDocCell_
 * Sheets の RichTextValue（1セル分）を Docs の TableCell に可能な限り忠実にコピー（堅牢版）
 * - 書式ラン（getRuns）の start/end を「排他的 end」で正規化し、範囲外はクランプ
 * - 太字/斜体/下線/取消線/色/サイズ/フォントを反映
 * - リンクは RichTextValue.getLinkUrl(start, endExclusive) または全体 getLinkUrl() を使用
 * - 段落整形は一切しない（ユーザーの書式を尊重）
 */
function copyRichTextToDocCell_(cellRich, tableCell) {
  // Docs 側セルに“空段落”を作り、編集対象を取得
  const paragraph = tableCell.appendParagraph('');
  const ed = paragraph.editAsText();

  if (!cellRich) return;                 // 値が無い
  const text = cellRich.getText() || ''; // 生文字
  if (text.length === 0) return;         // 空文字
  const L = text.length;

  const runs = cellRich.getRuns();       // 書式ラン配列（null/空あり）

  // 範囲を [0, L] にクランプ。end は排他的で統一
  const clampRange = (s, e) => {
    let start = Math.max(0, Math.min(L, (s|0)));
    let endEx = Math.max(0, Math.min(L, (e|0)));
    if (endEx <= start) return null;
    return { start, endEx };
  };

  if (runs && runs.length) {
    runs.forEach(run => {
      // run の end が包含/非包含で揺れるため、+1 してからクランプして安全化
      const sRaw = run.getStartIndex();
      const eRaw = run.getEndIndex() + 1;
      const rng = clampRange(sRaw, eRaw);
      if (!rng) return; // 空レンジはスキップ

      const seg = text.substring(rng.start, rng.endEx); // [start, endEx)
      const st  = run.getTextStyle();                   // ランのスタイル

      // 追加先の Docs 側文字位置
      const from = ed.getText().length;
      ed.appendText(seg);
      const to = from + seg.length - 1;                 // 包含終端

      // ---- 文字装飾 ----
      if (st) {
        if (st.isBold())          ed.setBold(from, to, true);
        if (st.isItalic())        ed.setItalic(from, to, true);
        if (st.isUnderline())     ed.setUnderline(from, to, true);
        if (st.isStrikethrough()) ed.setStrikethrough(from, to, true);

        const size  = st.getFontSize();
        const color = st.getForegroundColor();
        const fam   = st.getFontFamily();
        if (size)  ed.setFontSize(from, to, size);
        if (color) ed.setForegroundColor(from, to, color);
        if (fam)   ed.setFontFamily(from, to, fam);
      }

      // ---- リンク ----（RichTextStyle では取得できない）
      const linkUrl = cellRich.getLinkUrl(rng.start, rng.endEx); // [start, endEx)
      if (linkUrl) ed.setLinkUrl(from, to, linkUrl);
    });

  } else {
    // ランが無い場合：全体で適用
    ed.appendText(text);
    const from = 0, to = text.length - 1;

    const st = cellRich.getTextStyle(); // 全体スタイル
    if (st) {
      if (st.isBold())          ed.setBold(from, to, true);
      if (st.isItalic())        ed.setItalic(from, to, true);
      if (st.isUnderline())     ed.setUnderline(from, to, true);
      if (st.isStrikethrough()) ed.setStrikethrough(from, to, true);

      const size  = st.getFontSize();
      const color = st.getForegroundColor();
      const fam   = st.getFontFamily();
      if (size)  ed.setFontSize(from, to, size);
      if (color) ed.setForegroundColor(from, to, color);
      if (fam)   ed.setFontFamily(from, to, fam);
    }

    // 全体に同一リンクが付いている場合のみ返る
    const allLink = cellRich.getLinkUrl();
    if (allLink) ed.setLinkUrl(from, to, allLink);
  }

  // 段落の整列・インデント等は一切変更しない
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

