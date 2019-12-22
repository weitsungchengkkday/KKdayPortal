# KKdayPortal



## 登入流程

因為Mobile APP 無法直接使用 SAML, 所以APP端登入將分成兩個部分
PartI 使用WKWebView 完成SAML 登入的流程, PartII iOS APP 藉由 WKWebView 將 Web 上獲得的 Plone Restful API token 取回

### PartI WKWebView 

step1. Client 和SP 要資源
step2. SP 經由 Client 端 Redirect 到 IDP
step3. IDP 要求Client 端登入以驗證身份
step4. IDP 產生 SMAL Token, 經由 Client 端 Redirect 傳給 SP
(SMAL Token 為 SAML Assertion 是一個 XML document)
step5. SP 藉由 SMAL Token 確認用戶身份, 使用者登入

### PartII iOS APP 取得Plone資源

step a. Load Plone website by WKWebView
step b. Plone server 用 SAML Token 換  Restful API token
step c. Plone server 發出通知 , WKWebView 取得 Restful API token
