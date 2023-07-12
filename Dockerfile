FROM python:3-bullseye as git_clone

RUN apt-get update && apt-get install --yes --no-install-recommends git curl

RUN git clone --depth 1 https://github.com/4ch1m/pixoo-rest.git /usr/app && \
    rm -rf /usr/app/.git && \
    git clone --depth 1 https://github.com/SomethingWithComputers/pixoo.git /usr/app/pixoo && \
    rm -rf /usr/app/pixoo/.git

WORKDIR /usr/app

RUN pip install \
          --root-user-action=ignore \
          --no-cache-dir \
          --upgrade \
          --requirement requirements.txt

# COPY ./pixoo-rest/swag swag/
# COPY pixoo-rest/_helpers.py .
# COPY pixoo-rest/version.txt .
# COPY pixoo-rest/app.py .

HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl --fail --silent http://localhost:5000 || exit 1

CMD [ "gunicorn", "--bind", "0.0.0.0:5000", "app:app" ]
