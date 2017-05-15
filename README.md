# spip_statique
Transformer un site SPIP en site statique.
```
spip_statique http://localhost/mon_site/
```

## Usage

Choisir un répertoire dans lequel copier un site en html. 
```
cd ~/Sites/mon_site
```
Lancer `spip_statique`
```
spip_statique http://localhost/mon_site/
```
Le site http://localhost/mon_site/ est copié en HTML dans ~/Sites/mon_site

## Installation

installer `spip_statique` dans le terminal
```
cd ~/scripts
```
Copier-coller
```
git clone https://github.com/BoOz/spip_statique.git
cd spip_statique
chmod +x spip_statique.sh
```
Et valider

Le script `spip_statique.sh` fonctionne.
```
~/scripts/spip_statique/spip_statique.sh http://localhost/mon_site/
```

### Un alias dans le terminal
Ajouter un alias dans `~/.bash_profile`.
```
vim ~/.bash_profile
```
Taper `i` puis ajouter la ligne
```
alias spip_statique="~/scripts/spip_statique/spip_statique.sh"
```
Taper `esc` puis `:wq` et valider.

Relancer le terminal
```
. ~/.bash_profile
```
