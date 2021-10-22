FROM python:3.7-alpine
RUN adduser -D python
USER python
WORKDIR /home/python
COPY application /home/python
ENV PATH="/home/python/.local/bin:${PATH}"
RUN pip install --user -e . && python3.7 setup.py install --user
CMD python3 -m demo
