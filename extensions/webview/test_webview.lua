local webview           = require "hs.webview"
local timer             = require "hs.timer"

--
-- Variables:
--
local FRAME             = { x = 100, y = 100, w = 200, h = 200 }
local CLOSE_HTML        = "<html><body><script>window.close()</script></body></html>"

--
-- Test creating a new object:
--
function testNew()
  local webviewObject = webview.new(FRAME)
  assertIsUserdataOfType("hs.webview", webviewObject)
  assertTrue(#tostring(webviewObject) > 0)
  webviewObject:delete()
  return success()
end

--
-- Test the allowScriptClose getter and setter:
--
function testAllowScriptClose()
  local webviewObject = webview.new(FRAME)
  assertTrue(webviewObject:allowScriptClose())
  assertIsEqual(webviewObject, webviewObject:allowScriptClose(false))
  assertFalse(webviewObject:allowScriptClose())
  assertIsEqual(webviewObject, webviewObject:allowScriptClose(true))
  assertTrue(webviewObject:allowScriptClose())
  webviewObject:delete()
  return success()
end

--
-- Test that window.close() closes the window:
--
local scriptCloseTestObj = nil
local scriptCloseClosed = false

function testScriptClose()
  scriptCloseTestObj = webview.new(FRAME):windowStyle({"titled", "closable"}):deleteOnClose(true)
  scriptCloseTestObj:windowCallback(function(action) if action == "closing" then scriptCloseClosed = true end end)
  scriptCloseTestObj:html(CLOSE_HTML):show()
  return success()
end

function testScriptCloseValues()
  if scriptCloseClosed then
    scriptCloseTestObj = nil
    return success()
  else
    return "Waiting for window.close()..."
  end
end

--
-- Test that window.close() is ignored when allowScriptClose is false:
--
local scriptCloseDisabledTestObj = nil
local scriptCloseDisabledClosed = false
local scriptCloseDisabledLoadedAt = nil

function testScriptCloseDisabled()
  scriptCloseDisabledTestObj = webview.new(FRAME):windowStyle({"titled", "closable"}):deleteOnClose(true):allowScriptClose(false)
  scriptCloseDisabledTestObj:windowCallback(function(action) if action == "closing" then scriptCloseDisabledClosed = true end end)
  scriptCloseDisabledTestObj:navigationCallback(function(action)
    if action == "didFinishNavigation" then
      scriptCloseDisabledLoadedAt = timer.secondsSinceEpoch()
    end
  end)
  scriptCloseDisabledTestObj:html(CLOSE_HTML):show()
  return success()
end

function testScriptCloseDisabledValues()
  if scriptCloseDisabledClosed then
    return "Window was closed despite allowScriptClose(false)"
  elseif scriptCloseDisabledLoadedAt == nil or timer.secondsSinceEpoch() - scriptCloseDisabledLoadedAt < 1 then
    return "Waiting for page to load and window.close() to be ignored..."
  else
    scriptCloseDisabledTestObj:windowCallback(nil):delete()
    scriptCloseDisabledTestObj = nil
    return success()
  end
end
