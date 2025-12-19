#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    setWindowTitle("Qt Demo 01");
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_actionExit_triggered()
{
    close();
}

void MainWindow::on_actionAbout_triggered()
{
    QMessageBox::about(this, "About", "Qt Demo 01 Application\nBuilt with CMake and Qt 5");
}

void MainWindow::on_pushButton_clicked()
{
    QMessageBox::information(this, "Button Clicked", "You clicked the button!");
}
