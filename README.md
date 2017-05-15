# spip_statique
Transformer un site SPIP en site statique.
`spip_statique http://localhost/mon_site/`

**Usage**

Choisir un répertoire dans lequel copier un site en html. 
Exemple `cd ~/Sites/mon_site`

Lancer `spip_statique` :
```
~/scripts/spip_statique/spip_statique.sh http://localhost/mon_site/
```

**Installation**

Dans le terminal la première fois, installer `spip_statique`.
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

**Un alias dans le terminal**

Pour simplifier l'appel à `spip_statique`, on peut ajouter un alias dans `~/.bash_profile`.

```
vim ~/.bash_profile
```
Taper `i` puis ajouter la ligne

```
alias spip_statique="~/scripts/spip_statique/spip_statique.sh"
```
taper `esc` puis `:wq`, valider puis relancer le terminal
```
. ~/.bash_profile
```


**Usage simplifié**

```
spip_statique http://localhost/mon_site/
```

