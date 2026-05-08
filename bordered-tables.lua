-- bordered-tables.lua
-- Converte tutte le tabelle markdown in tabelle LaTeX con bordi completi
-- (linee orizzontali e verticali su tutte le celle).

if FORMAT:match('latex') then
  function Table(tbl)
    -- Rendi la tabella in LaTeX
    local doc = pandoc.Pandoc({ tbl })
    local latex = pandoc.write(doc, 'latex')

    -- 1. Aggiungi | tra le colonne nello spec
    latex = latex:gsub('{@{}([lcr]+)@{}}', function(cols)
      local out = '{|'
      for c in cols:gmatch('[lcr]') do
        out = out .. c .. '|'
      end
      return out .. '}'
    end)

    -- 2. Sostituisci booktabs rules con \hline
    latex = latex:gsub('\\toprule\\noalign{}', '\\hline')
    latex = latex:gsub('\\midrule\\noalign{}', '\\hline')
    latex = latex:gsub('\\bottomrule\\noalign{}', '\\hline')
    latex = latex:gsub('\\toprule', '\\hline')
    latex = latex:gsub('\\midrule', '\\hline')
    latex = latex:gsub('\\bottomrule', '\\hline')

    -- 3. Aggiungi \hline alla fine di ogni riga di dati
    --    Match: "\\\n" (fine riga) seguito da contenuto che NON inizia con \hline o \end
    latex = latex:gsub('\\\\\n(%s*)([^\\%s])', '\\\\\\hline\n%1%2')

    return pandoc.RawBlock('latex', latex)
  end
end
