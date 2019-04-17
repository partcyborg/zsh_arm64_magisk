# Zsh for Arm Devices

## Overview

Zsh is a shell designed for interactive use, although it is also a powerful scripting language. Many of the useful features of bash, ksh, and tcsh were incorporated into zsh; many original features were added. The [introductory document](http://zsh.sourceforge.net/Intro/intro_toc.html) details some of the unique features of zsh. It assumes basic knowledge of the standard UNIX shells; the intent is to show a reader already familiar with one of the other major shells what makes zsh more useful or more powerful. This document is not at all comprehensive; [read the manual](http://zsh.sourceforge.net/Doc/) entry for a description of the shell that is complete, concise and up-to-date, although somewhat overwhelming and devoid of examples. Alternatively, the [user guide](http://zsh.sourceforge.net/Guide/zshguide.html) offers wordy explanations of many of the shell's features. 

## Compatibility
Zsh was built for armv7, so it should work on any arm or arm64 device.

## Instructions
Just flash the zip in Magisk Manager, and you are good to go.  You can run Zsh at any time from either a terminal emulator or an adb session by just typing `zsh`.  

If you run Zsh as root, a home directory is automatically created for you at `/data/local/root`, and if ran as system one is created for you at `/data/local/system`.  Feel free to populate these with anything you like, however I personally only use it as the root user.  Application users don't have sufficient privileges to run this Zsh install.  If you want to use zsh at the application layer, I highly recommend [Termux](https://wiki.termux.com/wiki/Main_Page)

## Changelog

v0.8 - 1/18/2019
* Inaugral release!