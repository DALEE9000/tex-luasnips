## LuaSnips for LaTeX

This repo contains my library of LuaSnips for typesetting in LaTeX. [Daniel Sussman's notes](https://www.dmsussman.org/resources/luasnippets/) on the matter were enormously illuminating to follow.

I am not as of the time of this push a practitioner of Lua, so undoubtedly there is room for improvement. Please feel free to suggest any.

## Notes

### Trigger order matters

Most snippets use `wordTrig=false`, so a trigger also matches the tail of a longer word, and LuaSnip expands the **first** matching snippet in the file. A trigger that ends in another trigger must therefore come earlier in `tex.lua` — e.g. `vphi` before `phi`, and `beta`/`zeta`/`theta`/`Theta` before `eta`.

### Greek letters

| Trigger | Output | Trigger | Output |
|---|---|---|---|
| `alp` | `\alpha` | `nu` | `\nu` |
| `beta` | `\beta` | `xi` / `Xi` | `\xi` / `\Xi` |
| `gamma` / `Gamma` | `\gamma` / `\Gamma` | `pi` / `Pi` | `\pi` / `\Pi` |
| `delta` / `Delta` | `\delta` / `\Delta` | `vpi` | `\varpi` |
| `eps` / `veps` | `\epsilon` / `\varepsilon` | `rho` / `vrho` | `\rho` / `\varrho` |
| `zeta` | `\zeta` | `sig` / `Sig` | `\sigma` / `\Sigma` |
| `eta` | `\eta` | `vsig` | `\varsigma` |
| `theta` / `Theta` | `\theta` / `\Theta` | `tau` | `\tau` |
| `vth` | `\vartheta` | `ups` / `Ups` | `\upsilon` / `\Upsilon` |
| `iota` | `\iota` | `phi` / `Phi` | `\phi` / `\Phi` |
| `kap` | `\kappa` | `vphi` | `\varphi` |
| `lam` / `Lam` | `\lambda` / `\Lambda` | `chi` | `\chi` |
| `mu` | `\mu` | `psi` / `Psi` | `\psi` / `\Psi` |
| | | `om` / `Om` | `\omega` / `\Omega` |

Capitals that look like Latin letters (A, B, E, Z, H, I, K, M, N, O, P, T, X) have no LaTeX command; type the letter.

### `abs`

`abs` inserts `\abs{}`. In my solutions-manual headers, plain `\abs` autosizes (`\left| … \right|`) and `\abs*` keeps fixed-size bars.
