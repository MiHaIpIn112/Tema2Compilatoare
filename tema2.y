%{
#include<stdio.h>
#include<stdlib.h>
#include <string.h>


int yylex(void);
int yyerror(const char *msg);

int EsteCorecta = 0;

class TVAR
	{
	     char* nume;
	     int valoare;
	     TVAR* next;
	  
	  public:
	     static TVAR* head;
	     static TVAR* tail;

	     TVAR(char* n, int v = -1);
	     TVAR();
	     int exists(char* n);
             void add(char* n, int v = -1);
             int getValue(char* n);
	     void setValue(char* n, int v);
	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;

	TVAR::TVAR(char* n, int v)
	{
	 this->nume = new char[strlen(n)+1];
	 strcpy(this->nume,n);
	 this->valoare = v;
	 this->next = NULL;
	}

	TVAR::TVAR()
	{
	  TVAR::head = NULL;
	  TVAR::tail = NULL;
	}

	int TVAR::exists(char* n)
	{
	  TVAR* tmp = TVAR::head;
	  while(tmp != NULL)
	  {
	    if(strcmp(tmp->nume,n) == 0)
	      return 1;
            tmp = tmp->next;
	  }
	  return 0;
	 }

         void TVAR::add(char* n, int v)
	 {
	   TVAR* elem = new TVAR(n, v);
	   if(head == NULL)
	   {
	     TVAR::head = TVAR::tail = elem;
	   }
	   else
	   {
	     TVAR::tail->next = elem;
	     TVAR::tail = elem;
	   }
	 }

         int TVAR::getValue(char* n)
	 {
	   TVAR* tmp = TVAR::head;
	   while(tmp != NULL)
	   {
	     if(strcmp(tmp->nume,n) == 0)
	      return tmp->valoare;
	     tmp = tmp->next;
	   }
	   return -1;
	  }

	  void TVAR::setValue(char* n, int v)
	  {
	    TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
	      if(strcmp(tmp->nume,n) == 0)
	      {
		tmp->valoare = v;
	      }
	      tmp = tmp->next;
	    }
	  }

	TVAR* ts = NULL;
%}

%union {char* sir;int val;}
%locations
%token TOK_DECLARE TOK_BEGIN TOK_END TOK_ASIGN TOK_LEFT TOK_RIGHT TOK_READ TOK_WRITE TOK_FOR TOK_DO TOK_TO
%token <sir> TOK_VARIABLE TOK_PROGRAM
%token <val> TOK_INTEGER TOK_ID TOK_INT

%start P

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%

P : TOK_PROGRAM PN TOK_DECLARE DL TOK_BEGIN SL TOK_END
{
EsteCorecta=1;
}
  ;
PN : TOK_ID
   ;
DL : D 
   | DL ';' D
   ;
D : IL ':' T
  ;
T : TOK_INTEGER
  ;
IL : TOK_ID
   | IL ',' TOK_ID
   ;
SL : S
   | SL ';' S
   ;
S : A
  | R
  | W
  | F
  ;
A : TOK_ID TOK_ASIGN E
  ;
E : T
  | E TOK_PLUS T 
  | E TOK_MINUS T	 
  ;
T : F 
  | T TOK_MULTIPLY F 	 
  | T TOK_DIVIDE F   	
  ;
F : TOK_ID
  | TOK_INT		 
  | TOK_LEFT E TOK_RIGHT 
  ;
R : TOK_READ TOK_LEFT IL TOK_RIGHT
  ;
W : TOK_WRITE TOK_LEFT IL TOK_RIGHT
  ;
F : TOK_FOR IE TOK_DO B
  ;
IE : TOK_ID TOK_ASIGN E TOK_TO E
   ;
B : S
  | TOK_BEGIN SL TOK_END
  ;
%%


int main()
{
	yyparse();
	
	if(EsteCorecta == 1)
	{
		printf("CORECTA\n");		
	}	

       return 0;
}
int yyerror(const char *msg)
{
	printf("Error: %s\n", msg);
	return 1;
}


