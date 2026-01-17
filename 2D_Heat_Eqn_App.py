import sys
from PyQt5.QtGui import QFont,QPixmap,QIcon
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication, QWidget, QLabel, QPushButton, QLineEdit, QComboBox,QVBoxLayout

class App(QWidget):
    

    
    def __init__(self):
        QWidget.__init__(self)
        
        font_text=QFont()
        font_text.setPointSize(10)
    
        font_label=QFont()
        font_label.setPointSize(12)
        font_label.setBold(True)
        font_label.setUnderline(True)
        
        def label(name, move_x , move_y):
            
            self.label=QLabel(self)
            self.label.setText(name)
            self.label.move(move_x,move_y)
            self.label.setFont(font_label)
 
        label1=label("Object Details",10,20)
        label2=label("Discretized Domain",10,110)
        label3=label("Initial Condition",10,230)
        label4=label("Boundary Condition",10,300)
        
        def textbox(name,move_x,move_y,box_x,box_y):
            text=QLabel(self)
            text.setText(name)
            text.move(move_x,move_y)
            
        
            text.setFont(font_text)
            
            box=QLineEdit(self)
            box.move(box_x,box_y)
            box.setFixedSize(80,15)

        
        def dropbox(opt,x,y,x_box,y_box):  
            
             menu_box=QComboBox(self)
             menu_box.move(x,y)
             menu_box.addItems(opt)  
        
             self.menu_text=QLabel(self)
             self.menu_text.move(x_box,y_box)
             menu_box.activated[str].connect(self.onChanged)
        
           
        text1=textbox("Length: ",10,50,55,50) 
        text2=textbox("Width: ",10,85,52,85) 
        text3=textbox("Space step, \u0394x: ",10,140,100,140)
        text4=textbox("Space step, \u0394y: ",10,170,100,170)
        text4=textbox("Time step,  \u0394t: ",10,200,100,200)
        text4=textbox("Final time,  T: ",200,170,290,170)
        
        text5=textbox("Left Boundary Condition: ",10,325,155,325)
        text6=textbox("Right Boundary Condition: ",10,350,160,350)
        text7=textbox("Top Boundary Condition: ",10,375,155,375)
        text8=textbox("Bottom Boundary Condition: ",10,400,170,400)
    
        
        
                
        self.text=QLabel(self)
        self.text.setText("Material: ")
        self.text.move(150,50)
        
        option1=["Copper","Iron","Aluminium"]
        drop1=dropbox(option1,202,70,202,50)
        
        submit=QPushButton(self)
        submit.setText("Run Simulation")
        submit.move(150,450)
        submit.setFixedSize(100,40)
        submit.clicked.connect(self.taken_value)
        
        
    def onChanged(self,text):
            self.menu_text.setText(text)
            self.menu_text.adjustSize()
    
    def taken_value(self):
        a=self.menu_text.text()
        print(a)
    
       
def main():
    
    app=QApplication(sys.argv)
    
    widget=App()
    widget.setWindowTitle("2D Heat Equation Solver")
    widget.resize(400,500)
    widget.move(300,300)
    
    widget.show()
    sys.exit(app.exec_())
        
if __name__ == "__main__" :
        main()