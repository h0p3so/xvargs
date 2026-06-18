oxvargs = xvargs.o
otest = test.o
final = xvargs

all: $(final)

$(final): $(oxvargs) $(otest)
	ld	$(oxvargs) $(otest)	-o $(final)
$(oxvargs):
	gcc -c xvargs.S -o $(oxvargs) # -DXVARG_SAFE
$(otest):
	gcc -c test.S -o $(otest)
clean:
	rm	-f $(oxvargs) $(otest) $(final)
