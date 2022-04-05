#include<iostream>
#include<string>
#include<vector>
#include<Windows.h>
#include<cstring>
#pragma warning(disable:4996)

using namespace std;

class a1111
{
private:
	int a;
public:
	a1111(int aa) :a(aa)
	{ }

	virtual int geta() { return a; }

	void print_a()
	{
		cout << "a : " << a;
	}
};

class b1111:public a1111
{
private:
	int b1;
	int b2;
public:
	b1111(int ab1, int ab2):a1111(ab1),b2(ab2)
	{ }

	int getb() { return b2; }

	void print_b()
	{
		print_a();
		cout << "b : " << b2;
	}


	


};

int main(void)
{
	a1111 aaa(1);
	cout << aaa.geta();

	return 0;
}
