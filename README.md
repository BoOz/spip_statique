# spip_statique
Transformer un site SPIP en site statique.


**installation**

Choisir un répertoire, par exemple `~/scripts`, et s'y rendre via le terminal :
```
cd ~/scripts
```
puis installer `spip_statique` :

```
git clone https://github.com/BoOz/spip_statique.git
cd spip_statique
chmod +x spip_statique.sh
```

**usage**

Se rendre dans un répertoire dans lequel on souhaite copier un site, exemple `cd ~/Sites/mon_site`, et lancer la commande :
```
~/scripts/spip_statique/spip_statique.sh http://localhost/mon_site/
```

**un alias dans le terminal**

Pour simplifier l'appel à spip_statique, on peut ajouter un alias dans `~/.bash_profile`.

```
vim ~/.bash_profile
```
taper `i` puis ajouter la ligne

```
alias spip_statique="~/scripts/spip_statique/spip_statique.sh"
```
taper `esc` puis `:wq` et valider.

ensuite appeler la commande :

```
spip_statique http://localhost/mon_site/
```

