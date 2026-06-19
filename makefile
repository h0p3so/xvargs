objs = xvargs.o test.o
final = xvargs

all: $(final)

$(final): $(objs)
	ld	-o $(final) $(objs)
%.o: %.s
	as	-o $@ $<
clean:
	rm	-f $(objs) $(final)
