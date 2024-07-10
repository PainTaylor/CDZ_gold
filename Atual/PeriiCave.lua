UI.Label('Numero de Voltas')
UI.TextEdit(storage.voltas or "30", function(widget, newText)
storage.voltas = newText
end)